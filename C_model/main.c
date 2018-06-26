#include<vector>
#include<iostream>
#include<math.h>
using namespace std;

void show2D(vector<vector<int>>& l) {
    for(int i = 0;i < l.size();i++) {
	for(int j = 0;j < l[i].size();j++)
	    cout << l[i][j] << "\t";
	cout << endl;
    }
}

void TBT(vector<vector<int>>& X, vector<vector<int>>& TR, int l) {
    int n = X.size(), m = X[0].size();
    int B = (1<<l) - 1;
    for(int i = 0;i < n;i++) {
	for(int j = 0;j < m;j++) {
	    TR[i][j] = X[i][j] & B;
	    X[i][j] = X[i][j] >> l;
	}
    }
}

void IBP(vector<vector<int>>& X, int intra_mode, int l, int& IBP_mode, vector<vector<int>>& res) {
    // eight IBP mode
    auto mode = [](int intra_mode,int r1,int r2,int r3,int r4) {
	switch(intra_mode) {
	    case 0: return r1;
	    case 1: return r3;
	    case 2: return (r1+r2)>>1;
	    case 3: return (r3+r4)>>1;
	    case 4: return (r1+r4)>>1;
	    case 5: return (r1+r3)>>1;
	    case 6: return ((r1+r2)>>1 + r3)>>1;
	    case 7: return ((r1+r2)>>1 + (r3+r4)>>1)>>1;
	    default: return r1;
	}
    };

    //get X shape
    int n = X.size(), m = X[0].size();
    vector<vector<int>> domain = {{4,5,7},{4,5,7},{0,4,5},{0,2,6},{1,5,6},{1,3,4}};
    vector<int> modelist = domain[intra_mode];

    //IP
    res[0][0] = X[0][0];

    //left BP residual
    for(int i = 1;i < n;i++)
	res[i][0] = X[i][0] - X[i-1][0];
    //top BP residual
    for(int j = 1;j < m;j++)
	res[0][j] = X[0][j] - X[0][j-1];

    //NP residual
    vector<vector<vector<int>>> res_candidates = vector<vector<vector<int>>>(modelist.size(),vector<vector<int>>(n-1,vector<int>(m-1,0)));
    int r1, r2, r3, r4;
    vector<int> max_abs(modelist.size(),0);
    int tmp = 0;
    for(int k = 0;k < modelist.size();k++) {
	for(int i = 1;i < n;i++) {
	    for(int j = 1;j < m;j++) {
		r1 = X[i][j-1];
		r2 = X[i-1][j-1];
		r3 = X[i-1][j];
		r4 = j+1>=m?X[i][0]:X[i-1][j+1];
		res_candidates[k][i-1][j-1] = X[i][j] - mode(modelist[k],r1,r2,r3,r4);
		max_abs[k] = max(abs(res_candidates[k][i-1][j-1]),max_abs[k]);
	    }
	}
	if(max_abs[k] < max_abs[tmp])
	    tmp = k;
    }
    IBP_mode = modelist[tmp];
    for(int i = 1;i < n;i++)
	for(int j = 1;j < m;j++)
	    res[i][j] = res_candidates[tmp][i-1][j-1];
}

string exp_golomb(int x) {
    int n = abs(x);
    auto log2 = [](int n) {
	return log10(n)/log10(2);
    };
    int m = log2(n+1);
    int B = (1<<m) - 1;
    int r = (n+1) & B;
    string out(m,'1');
    out += '0';
    string tmp = "";
    for(int i = 0;i < m;i++) {
	if(r&1) tmp = "1" + tmp;
	else tmp = "0" + tmp;
	r = r>>1;
    }
    out += tmp;
    if(x < 0) out += '1';
    else if(x > 0) out += '0';
    return out;
}


void VLC(vector<vector<int>>& res, string& code) {
    for(int i = 0;i < res.size();i++) {
	for(int j = 0;j < res[i].size();j++) {
	    code += exp_golomb(res[i][j]);
	}
    }
}

int main() {
    int l = 1;
    vector<vector<int>> X = {{163,160,193,204,144,157,152,150},\
	{170,165,199,195,147,146,157,141},\
	{160,156,205,197,149,149,157,145},\
	{141,163,212,183,138,171,159,146},\
	{156,178,210,174,154,170,152,153},\
	{165,174,208,174,161,177,145,147},\
	{165,181,209,160,164,166,146,163},\
	{168,183,211,150,154,147,155,164}};
    
    cout << "origin X:" << endl;
    show2D(X);
    cout << endl;
    //TBT
    int n = X.size(), m = X[0].size();
    vector<vector<int>> TR = vector<vector<int>>(n,vector<int>(m,0));
    TBT(X,TR,l);

    cout << "new X:" << endl;
    show2D(X);
    cout << endl;

    cout << "TR:" << endl;
    show2D(TR);
    cout << endl;

    //IBP
    int intra_mode = 0;
    int IBP_mode = 0;
    vector<vector<int>> res(n,vector<int>(m,0));
    IBP(X, intra_mode, l, IBP_mode, res);

    cout << "IBP mode: " << IBP_mode << endl;
    cout << "IP and residual:" << endl;
    show2D(res);
    cout << endl;

    //VLC
    string code = "";
    VLC(res, code);
    cout << code << endl;

    return 0;
}

    



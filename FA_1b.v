// implemented by 0016002 舒俊維 

module FA_1b(in1, in2, cin, result, cout);

    input in1, in2, cin;
    output result, cout;

    assign result = in1 ^ in2 ^ cin;
    assign cout = (in1 & in2) | (in1 & cin) | (in2 & cin);
endmodule

`timescale 1ns/1ps

module des_encryption_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data_in;
    reg [55:0] key;
    reg rst;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    des_encryption dut (
        .clk(clk),
        .data_in(data_in),
        .key(key),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 64'h0;
            key = 56'h0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: All Zeros", test_num);
            reset_dut();
            data_in = 64'h0000000000000000;
            key     = 56'h00000000000000;


            repeat(20) @(posedge clk);



            #1;




            check_outputs(64'h8ca64de9c1b123a7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: All Ones", test_num);
            reset_dut();
            data_in = 64'hFFFFFFFFFFFFFFFF;
            key     = 56'hFFFFFFFFFFFFFF;

            repeat(20) @(posedge clk);


            #1;



            check_outputs(64'h7359b2163e4edc58);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Incremental Pattern", test_num);
            reset_dut();
            data_in = 64'h0123456789ABCDEF;
            key     = 56'h133457799BBCDF;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(64'h3fa40e8a984d4815);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Alternating Bits", test_num);
            reset_dut();
            data_in = 64'h5555555555555555;
            key     = 56'h2AAAAAAAAAAAAA;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(64'h246e9db9c550381a);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Data Stability Test", test_num);
            reset_dut();
            data_in = 64'hDEADBEEFCAFEBABE;
            key     = 56'h0123456789ABCD;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(64'h19870904225b1f81);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("des_encryption Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [63:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, data_in, key, rst, data_out);
    end

endmodule

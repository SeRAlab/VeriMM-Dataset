`timescale 1ns/1ps

module DES_Encryption_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data_in;
    reg [63:0] key_in;
    reg rst;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DES_Encryption dut (
        .clk(clk),
        .data_in(data_in),
        .key_in(key_in),
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
            key_in = 64'h0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Standard NIST Vector", test_num);

            key_in  = 64'h133457799BBCDFF1;
            data_in = 64'h0123456789ABCDEF;


            repeat (20) @(posedge clk);

            #1;


            check_outputs(64'h85E813540F0AB405);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Data", test_num);

            key_in  = 64'h0123456789ABCDEF;
            data_in = 64'h0000000000000000;

            repeat (20) @(posedge clk);

            #1;


            check_outputs(64'hD5D44FF720683D0D);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones Data and Key", test_num);

            key_in  = 64'hFFFFFFFFFFFFFFFF;
            data_in = 64'hFFFFFFFFFFFFFFFF;

            repeat (20) @(posedge clk);

            #1;


            check_outputs(64'h7359B2163E4EDC58);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Weak Key Property Test", test_num);

            key_in  = 64'h0E329232EA6D0D73;
            data_in = 64'h8787878787878787;

            repeat (20) @(posedge clk);

            #1;


            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: ASCII Text Encryption", test_num);

            key_in  = 64'h0123456789ABCDEF;
            data_in = 64'h4E6F772069732074;

            repeat (20) @(posedge clk);

            #1;


            check_outputs(64'h3FA40E8A984D4815);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DES_Encryption Testbench");
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
        $dumpvars(0,clk, data_in, key_in, rst, data_out);
    end

endmodule

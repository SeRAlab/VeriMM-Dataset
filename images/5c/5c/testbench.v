`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [15:0] d;
    reg reset;
    reg [4:0] slave_address;
    reg slave_read;
    wire [4:0] a;
    wire [15:0] slave_readdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .slave_address(slave_address),
        .slave_read(slave_read),
        .a(a),
        .slave_readdata(slave_readdata)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Read from Address 0", test_num);


            reset = 1;
            clk = 0;
            slave_address = 5'h00;
            slave_read = 1'b0;
            d = 16'h0000;
            #20;

            reset = 0;
            #20;


            slave_address = 5'h00;
            d = 16'hABCD;
            slave_read = 1'b1;


            #1;



            check_outputs(5'h00, 16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Read from Address 31", test_num);

            reset = 1; #20; reset = 0; #20;

            slave_address = 5'h1F;
            d = 16'hFFFF;
            slave_read = 1'b1;

            #1;


            check_outputs(5'h1F, 16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Read specific bit pattern", test_num);

            reset = 1; #20; reset = 0; #20;

            slave_address = 5'h0A;
            d = 16'h55AA;
            slave_read = 1'b1;

            #1;


            check_outputs(5'h0A, 16'h55AA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Address passthrough check", test_num);

            reset = 1; #20; reset = 0; #20;

            slave_address = 5'h15;
            d = 16'h1234;
            slave_read = 1'b0;



            #1;




            check_outputs(5'h15, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Post-reset mid-range read", test_num);


            reset = 1; #10; reset = 0; #10;

            slave_address = 5'h10;
            d = 16'hDEAD;
            slave_read = 1'b1;

            #1;


            check_outputs(5'h10, 16'hDEAD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [4:0] expected_a;
        input [15:0] expected_slave_readdata;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a === (expected_a ^ a ^ expected_a) &&
                expected_slave_readdata === (expected_slave_readdata ^ slave_readdata ^ expected_slave_readdata)) begin
                $display("PASS");
                $display("  Outputs: a=%h, slave_readdata=%h",
                         a, slave_readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%h, slave_readdata=%h",
                         expected_a, expected_slave_readdata);
                $display("  Got:      a=%h, slave_readdata=%h",
                         a, slave_readdata);
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

endmodule

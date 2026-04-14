`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] q_in;
    wire [7:0] q_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .q_in(q_in),
        .q_out(q_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        q_in = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones", test_num);
        q_in = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bit 7 to Bit 0", test_num);
        q_in = 8'h80;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bit 3 to Bit 1", test_num);
        q_in = 8'h08;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bit 6 to Bit 2", test_num);
        q_in = 8'h40;
        #1;

        check_outputs(8'h04);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bit 2 to Bit 3", test_num);
        q_in = 8'h04;
        #1;

        check_outputs(8'h08);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bit 5 to Bit 4", test_num);
        q_in = 8'h20;
        #1;

        check_outputs(8'h10);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bit 1 to Bit 5", test_num);
        q_in = 8'h02;
        #1;

        check_outputs(8'h20);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bit 4 to Bit 6", test_num);
        q_in = 8'h10;
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bit 0 to Bit 7", test_num);
        q_in = 8'h01;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern 0xAA (10101010)", test_num);
        q_in = 8'hAA;



        #1;




        check_outputs(8'h33);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern 0x55 (01010101)", test_num);
        q_in = 8'h55;



        #1;




        check_outputs(8'hCC);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern 0x0F (00001111)", test_num);
        q_in = 8'h0F;



        #1;




        check_outputs(8'hAA);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern 0xF0 (11110000)", test_num);
        q_in = 8'hF0;

        #1;


        check_outputs(8'h55);
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
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        
        
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
        input [7:0] expected_q_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q_out === (expected_q_out ^ q_out ^ expected_q_out)) begin
                $display("PASS");
                $display("  Outputs: q_out=%h",
                         q_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q_out=%h",
                         expected_q_out);
                $display("  Got:      q_out=%h",
                         q_out);
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

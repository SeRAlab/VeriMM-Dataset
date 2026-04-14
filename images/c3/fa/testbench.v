`timescale 1ns/1ps

module clock_and_case_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [3:0] sig;
    wire [7:0] thing;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_and_case dut (
        .clk(clk),
        .sig(sig),
        .thing(thing)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: sig = 4'b0000 (Set bit 0)", test_num);

        sig = 4'b1111;
        #20;


        sig = 4'b0000;
        @(posedge clk);
        #5;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: sig = 4'b0010 (Set bit 2)", test_num);

        sig = 4'b1111;
        #20;


        sig = 4'b0010;
        @(posedge clk);
        #5;
        #1;

        check_outputs(8'h04);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: sig = 4'b0011 (Set bit 9 - Out of bounds)", test_num);

        sig = 4'b1111;
        #20;


        sig = 4'b0011;
        @(posedge clk);
        #5;


        #1;



        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: sig = 4'b0111 (Undefined signal)", test_num);

        sig = 4'b0000;
        #20;


        sig = 4'b0111;
        @(posedge clk);
        #5;


        #1;



        check_outputs(8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("clock_and_case Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [7:0] expected_thing;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_thing === (expected_thing ^ thing ^ expected_thing)) begin
                $display("PASS");
                $display("  Outputs: thing=%h",
                         thing);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: thing=%h",
                         expected_thing);
                $display("  Got:      thing=%h",
                         thing);
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

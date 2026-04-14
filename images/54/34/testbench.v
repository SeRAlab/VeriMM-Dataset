`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] grant;
    reg [15:0] state;
    wire [15:0] new_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .grant(grant),
        .state(state),
        .new_state(new_state)
    );
    task testcase001;

    begin
        test_num = 1;
        state = 16'h0000;
        grant = 4'b0000;

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        state = 16'hABCD;
        grant = 4'b0000;

        #1;


        check_outputs(16'hABCD);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        state = 16'hAAAA;
        grant = 4'b0001;





        #1;






        check_outputs(16'hBBB0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        state = 16'hAAAA;
        grant = 4'b0010;





        #1;






        check_outputs(16'hA0AA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        state = 16'hAAAA;
        grant = 4'b0100;





        #1;






        check_outputs(16'hE0EE);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        state = 16'hAAAA;
        grant = 4'b1000;





        #1;






        check_outputs(16'h0AAA);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        state = 16'hFFFF;
        grant = 4'b1111;

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        state = 16'h0000;
        grant = 4'b0011;




        #1;





        check_outputs(16'h3300);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        state = 16'hFFFF;
        grant = 4'b1100;




        #1;





        check_outputs(16'h00FF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        state = 16'h1234;
        grant = 4'b0001;










        #1;











        check_outputs(16'h1330);
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
        input [15:0] expected_new_state;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_new_state === (expected_new_state ^ new_state ^ expected_new_state)) begin
                $display("PASS");
                $display("  Outputs: new_state=%h",
                         new_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_state=%h",
                         expected_new_state);
                $display("  Got:      new_state=%h",
                         new_state);
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

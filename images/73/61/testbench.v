`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] Columns;
    reg [3:0] Rows;
    wire [4:0] KeyNumber;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Columns(Columns),
        .Rows(Rows),
        .KeyNumber(KeyNumber)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: No key pressed (Idle)", test_num);
        Columns = 4'b0000;
        Rows = 4'b0000;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Row 0, Column 0 pressed", test_num);
        Columns = 4'b0001;
        Rows = 4'b0001;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Row 0, Column 1 pressed", test_num);
        Columns = 4'b0010;
        Rows = 4'b0001;
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Row 0, Column 2 pressed", test_num);
        Columns = 4'b0100;
        Rows = 4'b0001;
        #1;

        check_outputs(5'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Row 0, Column 3 pressed", test_num);
        Columns = 4'b1000;
        Rows = 4'b0001;
        #1;

        check_outputs(5'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Row 1, Column 0 pressed", test_num);
        Columns = 4'b0001;
        Rows = 4'b0010;
        #1;

        check_outputs(5'd4);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Row 1, Column 1 pressed", test_num);
        Columns = 4'b0010;
        Rows = 4'b0010;
        #1;

        check_outputs(5'd5);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Row 1, Column 2 pressed", test_num);
        Columns = 4'b0100;
        Rows = 4'b0010;
        #1;

        check_outputs(5'd6);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Row 1, Column 3 pressed", test_num);
        Columns = 4'b1000;
        Rows = 4'b0010;
        #1;

        check_outputs(5'd7);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Row 2, Column 0 pressed", test_num);
        Columns = 4'b0001;
        Rows = 4'b0100;
        #1;

        check_outputs(5'd8);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Row 2, Column 1 pressed", test_num);
        Columns = 4'b0010;
        Rows = 4'b0100;
        #1;

        check_outputs(5'd9);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Row 2, Column 2 pressed", test_num);
        Columns = 4'b0100;
        Rows = 4'b0100;
        #1;

        check_outputs(5'd10);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Row 2, Column 3 pressed", test_num);
        Columns = 4'b1000;
        Rows = 4'b0100;
        #1;

        check_outputs(5'd11);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Row 3, Column 0 pressed", test_num);
        Columns = 4'b0001;
        Rows = 4'b1000;
        #1;

        check_outputs(5'd12);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Row 3, Column 1 pressed", test_num);
        Columns = 4'b0010;
        Rows = 4'b1000;
        #1;

        check_outputs(5'd13);
    end
        endtask

    task testcase016;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Row 3, Column 2 pressed", test_num);
        Columns = 4'b0100;
        Rows = 4'b1000;
        #1;

        check_outputs(5'd14);
    end
        endtask

    task testcase017;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Row 3, Column 3 pressed", test_num);
        Columns = 4'b1000;
        Rows = 4'b1000;
        #1;

        check_outputs(5'd15);
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
        testcase015();
        testcase016();
        testcase017();
        
        
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
        input [4:0] expected_KeyNumber;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_KeyNumber === (expected_KeyNumber ^ KeyNumber ^ expected_KeyNumber)) begin
                $display("PASS");
                $display("  Outputs: KeyNumber=%h",
                         KeyNumber);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: KeyNumber=%h",
                         expected_KeyNumber);
                $display("  Got:      KeyNumber=%h",
                         KeyNumber);
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

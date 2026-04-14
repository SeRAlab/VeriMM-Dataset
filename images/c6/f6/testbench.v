`timescale 1ns/1ps

module Span12Mux_v3_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] I;
    reg [3:0] select;
    wire O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Span12Mux_v3 dut (
        .I(I),
        .select(select),
        .O(O)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select I[0] when it is 1", test_num);
        I = 12'b000000000001;
        select = 4'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select I[0] when it is 0", test_num);
        I = 12'b111111111110;
        select = 4'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select I[1] when it is 1", test_num);
        I = 12'b000000000010;
        select = 4'd1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select I[4] (Binary 4'b0100)", test_num);
        I = 12'b000000010000;
        select = 4'b0100;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select I[11] when it is 1", test_num);
        I = 12'b100000000000;
        select = 4'd11;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select I[11] when it is 0", test_num);
        I = 12'b011111111111;
        select = 4'd11;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pattern 12'hAAA, select even index 6", test_num);
        I = 12'hAAA;
        select = 4'd6;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pattern 12'hAAA, select odd index 7", test_num);
        I = 12'hAAA;
        select = 4'd7;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pattern 12'h555, select even index 2", test_num);
        I = 12'h555;
        select = 4'd2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs 1, select 5", test_num);
        I = 12'hFFF;
        select = 4'd5;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs 0, select 9", test_num);
        I = 12'h000;
        select = 4'd9;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Walking bit select 8", test_num);
        I = 12'b000100000000;
        select = 4'd8;
        #1;

        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Span12Mux_v3 Testbench");
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
        input expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%b",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%b",
                         expected_O);
                $display("  Got:      O=%b",
                         O);
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

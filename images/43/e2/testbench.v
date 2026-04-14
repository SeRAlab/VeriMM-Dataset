`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] BWD;
    reg FLOAT;
    reg [31:0] SRC1;
    reg [31:0] SRC2;
    wire [31:0] DEST1;
    wire [31:0] DEST2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BWD(BWD),
        .FLOAT(FLOAT),
        .SRC1(SRC1),
        .SRC2(SRC2),
        .DEST1(DEST1),
        .DEST2(DEST2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: BWD=00 (Byte), FLOAT=0 (Sign Extension) - Negative Values", test_num);
            BWD = 2'b00;
            FLOAT = 1'b0;
            SRC1 = 32'h000000FF;
            SRC2 = 32'h00000080;
            #1;

            check_outputs(32'hFFFFFFFF, 32'hFFFFFF80);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: BWD=00 (Byte), FLOAT=0 (Sign Extension) - Positive Values", test_num);
            BWD = 2'b00;
            FLOAT = 1'b0;
            SRC1 = 32'h0000007F;
            SRC2 = 32'h00000001;
            #1;

            check_outputs(32'h0000007F, 32'h00000001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: BWD=00 (Byte), FLOAT=1 (Zero Extension)", test_num);
            BWD = 2'b00;
            FLOAT = 1'b1;
            SRC1 = 32'h000000FF;
            SRC2 = 32'h00000080;
            #1;

            check_outputs(32'h000000FF, 32'h00000080);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: BWD=01 (Half-word), FLOAT=0 (Sign Extension) - Negative Values", test_num);
            BWD = 2'b01;
            FLOAT = 1'b0;
            SRC1 = 32'h0000FFFF;
            SRC2 = 32'h00008000;
            #1;

            check_outputs(32'hFFFFFFFF, 32'hFFFF8000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: BWD=01 (Half-word), FLOAT=0 (Sign Extension) - Positive Values", test_num);
            BWD = 2'b01;
            FLOAT = 1'b0;
            SRC1 = 32'h00007FFF;
            SRC2 = 32'h00000ABC;
            #1;

            check_outputs(32'h00007FFF, 32'h00000ABC);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: BWD=01 (Half-word), FLOAT=1 (Zero Extension)", test_num);
            BWD = 2'b01;
            FLOAT = 1'b1;
            SRC1 = 32'h0000FFFF;
            SRC2 = 32'h00008000;
            #1;

            check_outputs(32'h0000FFFF, 32'h00008000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: BWD=10 (Word), FLOAT=0 (Passthrough)", test_num);
            BWD = 2'b10;
            FLOAT = 1'b0;
            SRC1 = 32'hDEADBEEF;
            SRC2 = 32'h12345678;
            #1;

            check_outputs(32'hDEADBEEF, 32'h12345678);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: BWD=11 (Passthrough/Default Condition)", test_num);
            BWD = 2'b11;
            FLOAT = 1'b0;
            SRC1 = 32'hA5A5A5A5;
            SRC2 = 32'h5A5A5A5A;
            #1;

            check_outputs(32'hA5A5A5A5, 32'h5A5A5A5A);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Byte Sign Extension with upper bits set in SRC", test_num);

            BWD = 2'b00;
            FLOAT = 1'b0;
            SRC1 = 32'h123456FF;
            SRC2 = 32'hEDCBA001;
            #1;

            check_outputs(32'hFFFFFFFF, 32'h00000001);
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
        input [31:0] expected_DEST1;
        input [31:0] expected_DEST2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DEST1 === (expected_DEST1 ^ DEST1 ^ expected_DEST1) &&
                expected_DEST2 === (expected_DEST2 ^ DEST2 ^ expected_DEST2)) begin
                $display("PASS");
                $display("  Outputs: DEST1=%h, DEST2=%h",
                         DEST1, DEST2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DEST1=%h, DEST2=%h",
                         expected_DEST1, expected_DEST2);
                $display("  Got:      DEST1=%h, DEST2=%h",
                         DEST1, DEST2);
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

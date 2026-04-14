`timescale 1ns/1ps

module sll_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [4:0] shift_amount;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sll_32bit dut (
        .A(A),
        .shift_amount(shift_amount),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 32'h12345678;
            shift_amount = 5'd0;
            $display("Test Case %0d: Shift by 0 (Identity)", test_num);
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 32'h00000001;
            shift_amount = 5'd1;
            $display("Test Case %0d: Shift 1 left by 1", test_num);
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 32'h00000001;
            shift_amount = 5'd31;
            $display("Test Case %0d: Shift 1 left by 31 (To MSB)", test_num);
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 32'hFFFFFFFF;
            shift_amount = 5'd4;
            $display("Test Case %0d: Shift all 1s left by 4", test_num);
            #1;

            check_outputs(32'hFFFFFFF0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 32'hFFFFFFFF;
            shift_amount = 5'd16;
            $display("Test Case %0d: Shift all 1s left by 16", test_num);
            #1;

            check_outputs(32'hFFFF0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 32'hAAAAAAAA;
            shift_amount = 5'd8;
            $display("Test Case %0d: Shift pattern AA left by 8", test_num);
            #1;

            check_outputs(32'hAAAAAA00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 32'h80000000;
            shift_amount = 5'd1;
            $display("Test Case %0d: Shift MSB out of bounds", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 32'h00000000;
            shift_amount = 5'd15;
            $display("Test Case %0d: Shift zero value", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 32'hDEADBEEF;
            shift_amount = 5'd12;
            $display("Test Case %0d: Shift DEADBEEF left by 12", test_num);
            #1;

            check_outputs(32'hDBEEF000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 32'hF0F0F0F0;
            shift_amount = 5'd31;
            $display("Test Case %0d: Shift pattern left by 31", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sll_32bit Testbench");
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
        input [31:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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

`timescale 1ns/1ps

module barrel_shifter_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg dir;
    reg [4:0] shamt;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter_32bit dut (
        .a(a),
        .dir(dir),
        .shamt(shamt),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left Shift by 0", test_num);
            a = 32'hDEADBEEF;
            shamt = 5'd0;
            dir = 1'b0;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right Shift by 0", test_num);
            a = 32'hDEADBEEF;
            shamt = 5'd0;
            dir = 1'b1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left Shift by 1", test_num);
            a = 32'h00000001;
            shamt = 5'd1;
            dir = 1'b0;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right Shift by 1", test_num);
            a = 32'h80000000;
            shamt = 5'd1;
            dir = 1'b1;
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left Shift by 4", test_num);
            a = 32'h12345678;
            shamt = 5'd4;
            dir = 1'b0;
            #1;

            check_outputs(32'h23456780);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right Shift by 4", test_num);
            a = 32'h12345678;
            shamt = 5'd4;
            dir = 1'b1;
            #1;

            check_outputs(32'h01234567);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left Shift by 31", test_num);
            a = 32'h00000001;
            shamt = 5'd31;
            dir = 1'b0;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right Shift by 31", test_num);
            a = 32'h80000000;
            shamt = 5'd31;
            dir = 1'b1;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right Shift 0-fill check", test_num);
            a = 32'hFFFFFFFF;
            shamt = 5'd16;
            dir = 1'b1;
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left Shift 0-fill check", test_num);
            a = 32'hFFFFFFFF;
            shamt = 5'd16;
            dir = 1'b0;
            #1;

            check_outputs(32'hFFFF0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("barrel_shifter_32bit Testbench");
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
        input [31:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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

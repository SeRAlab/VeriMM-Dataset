`timescale 1ns/1ps

module barrel_shifter_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg direction;
    reg [4:0] shift;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter_32bit dut (
        .a(a),
        .direction(direction),
        .shift(shift),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Shift Left", test_num);
            a = 32'hA5A5A5A5;
            shift = 5'd0;
            direction = 1'b0;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Shift Right", test_num);
            a = 32'h5A5A5A5A;
            shift = 5'd0;
            direction = 1'b1;
            #1;

            check_outputs(32'h5A5A5A5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left Shift by 1", test_num);
            a = 32'h00000001;
            shift = 5'd1;
            direction = 1'b0;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right Shift by 1", test_num);
            a = 32'h80000000;
            shift = 5'd1;
            direction = 1'b1;
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left Shift by 8 (Sub-module boundary)", test_num);
            a = 32'h000000FF;
            shift = 5'd8;
            direction = 1'b0;
            #1;

            check_outputs(32'h0000FF00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right Shift by 8 (Sub-module boundary)", test_num);
            a = 32'hFF000000;
            shift = 5'd8;
            direction = 1'b1;
            #1;

            check_outputs(32'h00FF0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left Shift by 16", test_num);
            a = 32'h0000FFFF;
            shift = 5'd16;
            direction = 1'b0;
            #1;

            check_outputs(32'hFFFF0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right Shift by 16", test_num);
            a = 32'hFFFF0000;
            shift = 5'd16;
            direction = 1'b1;
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left Shift by 31 (Max Shift)", test_num);
            a = 32'h00000001;
            shift = 5'd31;
            direction = 1'b0;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right Shift by 31 (Max Shift)", test_num);
            a = 32'h80000000;
            shift = 5'd31;
            direction = 1'b1;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern Left Shift", test_num);
            a = 32'h12345678;
            shift = 5'd4;
            direction = 1'b0;
            #1;

            check_outputs(32'h23456780);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern Right Shift", test_num);
            a = 32'h12345678;
            shift = 5'd4;
            direction = 1'b1;
            #1;

            check_outputs(32'h01234567);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift out all bits (Left)", test_num);
            a = 32'hFFFFFFFF;
            shift = 5'd31;
            direction = 1'b0;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random pattern shift", test_num);
            a = 32'hCAFEFACE;
            shift = 5'd12;
            direction = 1'b0;
            #1;

            check_outputs(32'hEFACE000);
        end
        endtask

    task testcase015;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random pattern shift right", test_num);
            a = 32'hCAFEFACE;
            shift = 5'd12;
            direction = 1'b1;
            #1;

            check_outputs(32'h000CAFEF);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        
        
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

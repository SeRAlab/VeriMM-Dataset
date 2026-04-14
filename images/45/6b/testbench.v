`timescale 1ns/1ps

module mux_2to1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg sel;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2to1 dut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select Input A (AA) with sel=0", test_num);
            sel = 1'b0;
            a = 8'hAA;
            b = 8'h55;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select Input B (55) with sel=1", test_num);
            sel = 1'b1;
            a = 8'hAA;
            b = 8'h55;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select Input A (All Zeros) with sel=0", test_num);
            sel = 1'b0;
            a = 8'h00;
            b = 8'hFF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select Input B (All Ones) with sel=1", test_num);
            sel = 1'b1;
            a = 8'h00;
            b = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select Input A (All Ones) with sel=0", test_num);
            sel = 1'b0;
            a = 8'hFF;
            b = 8'h00;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select Input B (All Zeros) with sel=1", test_num);
            sel = 1'b1;
            a = 8'hFF;
            b = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternate Data Pattern, Select A", test_num);
            sel = 1'b0;
            a = 8'h12;
            b = 8'h34;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternate Data Pattern, Select B", test_num);
            sel = 1'b1;
            a = 8'h12;
            b = 8'h34;
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High-Nibble/Low-Nibble Select A", test_num);
            sel = 1'b0;
            a = 8'hF0;
            b = 8'h0F;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High-Nibble/Low-Nibble Select B", test_num);
            sel = 1'b1;
            a = 8'hF0;
            b = 8'h0F;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_2to1 Testbench");
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
        input [7:0] expected_y;
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

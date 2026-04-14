`timescale 1ns/1ps

module mux_4to1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    reg [1:0] sel;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_4to1 dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Select Input A (sel = 00)");
            a = 8'hAA;
            b = 8'hBB;
            c = 8'hCC;
            d = 8'hDD;
            sel = 2'b00;
            #10;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Select Input B (sel = 01)");
            a = 8'h11;
            b = 8'h22;
            c = 8'h33;
            d = 8'h44;
            sel = 2'b01;
            #10;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Select Input C (sel = 10)");
            a = 8'h0F;
            b = 8'hF0;
            c = 8'hA5;
            d = 8'h5A;
            sel = 2'b10;
            #10;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Select Input D (sel = 11)");
            a = 8'h00;
            b = 8'hFF;
            c = 8'h55;
            d = 8'hAA;
            sel = 2'b11;
            #10;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Boundary Condition - All Zeros");
            a = 8'h00;
            b = 8'h00;
            c = 8'h00;
            d = 8'h00;
            sel = 2'b10;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Boundary Condition - All Ones");
            a = 8'hFF;
            b = 8'hFF;
            c = 8'hFF;
            d = 8'hFF;
            sel = 2'b01;
            #10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Sequential Selection Change");
            a = 8'h01;
            b = 8'h02;
            c = 8'h03;
            d = 8'h04;

            sel = 2'b00; #5;
            sel = 2'b11; #5;
            #1;

            check_outputs(8'h04);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_4to1 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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

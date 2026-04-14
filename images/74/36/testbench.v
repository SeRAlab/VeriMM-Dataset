`timescale 1ns/1ps

module mux4to1_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    reg [1:0] sel;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1 dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select input A (sel=2'b00)", test_num);
            a = 4'h5;
            b = 4'hA;
            c = 4'h3;
            d = 4'hC;
            sel = 2'b00;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select input B (sel=2'b01)", test_num);
            a = 4'h5;
            b = 4'hA;
            c = 4'h3;
            d = 4'hC;
            sel = 2'b01;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select input C (sel=2'b10)", test_num);
            a = 4'h5;
            b = 4'hA;
            c = 4'h3;
            d = 4'hC;
            sel = 2'b10;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select input D (sel=2'b11)", test_num);
            a = 4'h5;
            b = 4'hA;
            c = 4'h3;
            d = 4'hC;
            sel = 2'b11;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs logic high (0xF)", test_num);
            a = 4'hF;
            b = 4'hF;
            c = 4'hF;
            d = 4'hF;
            sel = 2'b01;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs logic low (0x0)", test_num);
            a = 4'h0;
            b = 4'h0;
            c = 4'h0;
            d = 4'h0;
            sel = 2'b10;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking bit test on input A", test_num);
            a = 4'b0001; b = 4'h0; c = 4'h0; d = 4'h0; sel = 2'b00;
            #1;
            a = 4'b0010;
            #1;
            a = 4'b0100;
            #1;
            a = 4'b1000;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle select with different values", test_num);
            a = 4'h1; b = 4'h2; c = 4'h4; d = 4'h8;
            sel = 2'b11;
            #1;

            check_outputs(4'h8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4to1 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_y;
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

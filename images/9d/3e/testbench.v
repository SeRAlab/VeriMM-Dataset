`timescale 1ns/1ps

module mux2to1_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg sel;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux2to1_16bit dut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select Input A (All zeros vs All ones)", test_num);
            a = 16'h0000;
            b = 16'hFFFF;
            sel = 1'b0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select Input B (All zeros vs All ones)", test_num);
            a = 16'h0000;
            b = 16'hFFFF;
            sel = 1'b1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select Input A (Checkerboard patterns)", test_num);
            a = 16'hAAAA;
            b = 16'h5555;
            sel = 1'b0;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select Input B (Checkerboard patterns)", test_num);
            a = 16'hAAAA;
            b = 16'h5555;
            sel = 1'b1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select Input A (Random values)", test_num);
            a = 16'h1234;
            b = 16'hABCD;
            sel = 1'b0;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select Input B (Random values)", test_num);
            a = 16'h1234;
            b = 16'hABCD;
            sel = 1'b1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary check (Input A all ones)", test_num);
            a = 16'hFFFF;
            b = 16'h0000;
            sel = 1'b0;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary check (Input B all ones)", test_num);
            a = 16'h0000;
            b = 16'hFFFF;
            sel = 1'b1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High-byte/Low-byte separation check (Sel A)", test_num);
            a = 16'hFF00;
            b = 16'h00FF;
            sel = 1'b0;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High-byte/Low-byte separation check (Sel B)", test_num);
            a = 16'hFF00;
            b = 16'h00FF;
            sel = 1'b1;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux2to1_16bit Testbench");
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
        input [15:0] expected_y;
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

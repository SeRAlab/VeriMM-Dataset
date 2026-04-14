`timescale 1ns/1ps

module mux_8bit_4to1_tb;

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
    mux_8bit_4to1 dut (
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
            $display("Test Case %0d: Select Input A (sel=00)", test_num);
            a = 8'hA5; b = 8'h5A; c = 8'hFF; d = 8'h00;
            sel = 2'b00;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input B (sel=01)", test_num);
            a = 8'h12; b = 8'h34; c = 8'h56; d = 8'h78;
            sel = 2'b01;
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input C (sel=10)", test_num);
            a = 8'h01; b = 8'h02; c = 8'h03; d = 8'h04;
            sel = 2'b10;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input D (sel=11)", test_num);
            a = 8'hDE; b = 8'hAD; c = 8'hBE; d = 8'hEF;
            sel = 2'b11;
            #1;

            check_outputs(8'hEF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Inputs Identical (sel=10)", test_num);
            a = 8'hCC; b = 8'hCC; c = 8'hCC; d = 8'hCC;
            sel = 2'b10;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Values Check (sel=01)", test_num);
            a = 8'hFF; b = 8'h00; c = 8'hFF; d = 8'hFF;
            sel = 2'b01;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Values Check (sel=11)", test_num);
            a = 8'h00; b = 8'h00; c = 8'h00; d = 8'hFF;
            sel = 2'b11;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle Select bit 0 (00 to 01)", test_num);
            a = 8'hAA; b = 8'hBB; c = 8'hCC; d = 8'hDD;
            sel = 2'b00;
            #5;
            sel = 2'b01;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle Select bit 1 (01 to 11)", test_num);
            a = 8'h11; b = 8'h22; c = 8'h33; d = 8'h44;
            sel = 2'b01;
            #5;
            sel = 2'b11;
            #1;

            check_outputs(8'h44);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking Bit Pattern", test_num);
            a = 8'b00000001; b = 8'b00000010; c = 8'b00000100; d = 8'b00001000;
            sel = 2'b10;
            #1;

            check_outputs(8'b00000100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_8bit_4to1 Testbench");
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

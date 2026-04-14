`timescale 1ns/1ps

module mux6to1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    reg [7:0] e;
    reg [7:0] f;
    reg [2:0] sel;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux6to1 dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select Input A (sel=0)", test_num);
            a = 8'hAA; b = 8'hBB; c = 8'hCC; d = 8'hDD; e = 8'hEE; f = 8'hFF;
            sel = 3'b000;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select Input B (sel=1)", test_num);
            a = 8'h01; b = 8'h02; c = 8'h03; d = 8'h04; e = 8'h05; f = 8'h06;
            sel = 3'b001;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select Input C (sel=2)", test_num);
            a = 8'h10; b = 8'h20; c = 8'h30; d = 8'h40; e = 8'h50; f = 8'h60;
            sel = 3'b010;
            #1;

            check_outputs(8'h30);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select Input D (sel=3)", test_num);
            a = 8'hDE; b = 8'hAD; c = 8'hBE; d = 8'hEF; e = 8'hCA; f = 8'hFE;
            sel = 3'b011;
            #1;

            check_outputs(8'hEF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select Input E (sel=4)", test_num);
            a = 8'h11; b = 8'h22; c = 8'h33; d = 8'h44; e = 8'h55; f = 8'h66;
            sel = 3'b100;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select Input F (sel=5)", test_num);
            a = 8'hFF; b = 8'hEE; c = 8'hDD; d = 8'hCC; e = 8'hBB; f = 8'hAA;
            sel = 3'b101;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: All inputs zero, select A", test_num);
            a = 8'h00; b = 8'h00; c = 8'h00; d = 8'h00; e = 8'h00; f = 8'h00;
            sel = 3'b000;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Maximum values, select F", test_num);
            a = 8'hFF; b = 8'hFF; c = 8'hFF; d = 8'hFF; e = 8'hFF; f = 8'hFF;
            sel = 3'b101;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Boundary Select (sel=6) - Usually returns 0 or default", test_num);
            a = 8'h01; b = 8'h02; c = 8'h03; d = 8'h04; e = 8'h05; f = 8'h06;
            sel = 3'b110;

            #1;


            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux6to1 Testbench");
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

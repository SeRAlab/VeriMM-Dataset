`timescale 1ns/1ps

module mux8to1_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    reg [3:0] e;
    reg [3:0] f;
    reg [3:0] g;
    reg [3:0] h;
    reg [2:0] sel;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux8to1 dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .h(h),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select input A", test_num);
            a = 4'hA; b = 4'h0; c = 4'h1; d = 4'h2;
            e = 4'h3; f = 4'h4; g = 4'h5; h = 4'h6;
            sel = 3'b000;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select input B", test_num);
            a = 4'h0; b = 4'hB; c = 4'h1; d = 4'h2;
            e = 4'h3; f = 4'h4; g = 4'h5; h = 4'h6;
            sel = 3'b001;
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select input C", test_num);
            a = 4'h0; b = 4'h1; c = 4'hC; d = 4'h2;
            e = 4'h3; f = 4'h4; g = 4'h5; h = 4'h6;
            sel = 3'b010;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select input D", test_num);
            a = 4'h0; b = 4'h1; c = 4'h2; d = 4'hD;
            e = 4'h3; f = 4'h4; g = 4'h5; h = 4'h6;
            sel = 3'b011;
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select input E", test_num);
            a = 4'h0; b = 4'h1; c = 4'h2; d = 4'h3;
            e = 4'hE; f = 4'h4; g = 4'h5; h = 4'h6;
            sel = 3'b100;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select input F", test_num);
            a = 4'h0; b = 4'h1; c = 4'h2; d = 4'h3;
            e = 4'h4; f = 4'hF; g = 4'h5; h = 4'h6;
            sel = 3'b101;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select input G", test_num);
            a = 4'h0; b = 4'h1; c = 4'h2; d = 4'h3;
            e = 4'h4; f = 4'h5; g = 4'h7; h = 4'h6;
            sel = 3'b110;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select input H", test_num);
            a = 4'h0; b = 4'h1; c = 4'h2; d = 4'h3;
            e = 4'h4; f = 4'h5; g = 4'h6; h = 4'h8;
            sel = 3'b111;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All inputs same value, check transparency", test_num);
            a = 4'h5; b = 4'h5; c = 4'h5; d = 4'h5;
            e = 4'h5; f = 4'h5; g = 4'h5; h = 4'h5;
            sel = 3'b101;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating bit pattern", test_num);
            a = 4'hF; b = 4'h0; c = 4'hF; d = 4'h0;
            e = 4'hF; f = 4'h0; g = 4'hF; h = 4'h0;
            sel = 3'b111;
            #1;

            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux8to1 Testbench");
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

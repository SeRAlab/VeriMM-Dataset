`timescale 1ns/1ps

module mux_4to1_4bit_tb;

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
    mux_4to1_4bit dut (
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
            a = 4'hA;
            b = 4'h5;
            c = 4'hF;
            d = 4'h0;
            sel = 2'b00;
            $display("Test %0d: Select Input A (sel=00)", test_num);
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 4'hA;
            b = 4'h5;
            c = 4'hF;
            d = 4'h0;
            sel = 2'b01;
            $display("Test %0d: Select Input B (sel=01)", test_num);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 4'hA;
            b = 4'h5;
            c = 4'hF;
            d = 4'h0;
            sel = 2'b10;
            $display("Test %0d: Select Input C (sel=10)", test_num);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 4'hA;
            b = 4'h5;
            c = 4'hF;
            d = 4'h0;
            sel = 2'b11;
            $display("Test %0d: Select Input D (sel=11)", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 4'h1;
            b = 4'h2;
            c = 4'h4;
            d = 4'h8;
            sel = 2'b10;
            $display("Test %0d: Update data and select Input C (sel=10)", test_num);
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 4'hE;
            b = 4'hD;
            c = 4'hB;
            d = 4'h7;
            sel = 2'b01;
            $display("Test %0d: Update data and select Input B (sel=01)", test_num);
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 4'hF;
            b = 4'hF;
            c = 4'hF;
            d = 4'hF;
            sel = 2'b11;
            $display("Test %0d: All inputs high (sel=11)", test_num);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 4'h0;
            b = 4'h0;
            c = 4'h0;
            d = 4'h0;
            sel = 2'b00;
            $display("Test %0d: All inputs low (sel=00)", test_num);
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
        $display("mux_4to1_4bit Testbench");
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

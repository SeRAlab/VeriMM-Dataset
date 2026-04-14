`timescale 1ns/1ps

module mux_4to1_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] a;
    reg [1:0] b;
    reg [1:0] c;
    reg [1:0] d;
    reg [1:0] sel;
    wire [1:0] y;

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
            test_num = test_num + 1;
            $display("Test case %0d: Select input 'a' (sel=00)", test_num);
            a = 2'b11;
            b = 2'b00;
            c = 2'b01;
            d = 2'b10;
            sel = 2'b00;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test case %0d: Select input 'b' (sel=01)", test_num);
            a = 2'b11;
            b = 2'b01;
            c = 2'b10;
            d = 2'b00;
            sel = 2'b01;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test case %0d: Select input 'c' (sel=10)", test_num);
            a = 2'b00;
            b = 2'b01;
            c = 2'b10;
            d = 2'b11;
            sel = 2'b10;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test case %0d: Select input 'd' (sel=11)", test_num);
            a = 2'b10;
            b = 2'b11;
            c = 2'b01;
            d = 2'b00;
            sel = 2'b11;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test case %0d: Verify 'a' with different data", test_num);
            a = 2'b01;
            b = 2'b11;
            c = 2'b11;
            d = 2'b11;
            sel = 2'b00;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test case %0d: All inputs same, toggle select", test_num);
            a = 2'b10;
            b = 2'b10;
            c = 2'b10;
            d = 2'b10;
            sel = 2'b01;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test case %0d: Maximum values (all bits high)", test_num);
            a = 2'b11;
            b = 2'b11;
            c = 2'b11;
            d = 2'b11;
            sel = 2'b11;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test case %0d: Minimum values (all bits low)", test_num);
            a = 2'b00;
            b = 2'b00;
            c = 2'b00;
            d = 2'b00;
            sel = 2'b10;
            #1;

            check_outputs(2'b00);
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
        input [1:0] expected_y;
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

`timescale 1ns/1ps

module mux_4to1_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg [15:0] d;
    reg [1:0] sel;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_4to1_16bit dut (
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
            a = 16'hAAAA;
            b = 16'h5555;
            c = 16'h0000;
            d = 16'hFFFF;
            sel = 2'b00;
            $display("Test %0d: Select Port A (sel=00)", test_num);
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 16'hAAAA;
            b = 16'h5555;
            c = 16'h0000;
            d = 16'hFFFF;
            sel = 2'b01;
            $display("Test %0d: Select Port B (sel=01)", test_num);
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 16'hAAAA;
            b = 16'h5555;
            c = 16'h1234;
            d = 16'hFFFF;
            sel = 2'b10;
            $display("Test %0d: Select Port C (sel=10)", test_num);
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 16'hAAAA;
            b = 16'h5555;
            c = 16'h0000;
            d = 16'hFFFF;
            sel = 2'b11;
            $display("Test %0d: Select Port D (sel=11)", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 16'h0000;
            b = 16'hFFFF;
            c = 16'hFFFF;
            d = 16'hFFFF;
            sel = 2'b00;
            $display("Test %0d: Zero value passthrough on Port A", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 16'h0000;
            b = 16'h0000;
            c = 16'hFFFF;
            d = 16'h0000;
            sel = 2'b10;
            $display("Test %0d: All-ones value passthrough on Port C", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            sel = 2'b01;
            a = 16'h1111;
            b = 16'hBEEF;
            c = 16'h3333;
            d = 16'h4444;
            $display("Test %0d: Data update on active port B", test_num);
            #1;

            check_outputs(16'hBEEF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_4to1_16bit Testbench");
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

`timescale 1ns/1ps

module mux_4to1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    reg [1:0] sel;
    wire [7:0] out;

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
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select Input A (sel=00)", test_num);
            a = 8'hA5;
            b = 8'h00;
            c = 8'hFF;
            d = 8'h12;
            sel = 2'b00;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select Input B (sel=01)", test_num);
            a = 8'h00;
            b = 8'h5A;
            c = 8'hCC;
            d = 8'h33;
            sel = 2'b01;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select Input C (sel=10)", test_num);
            a = 8'h11;
            b = 8'h22;
            c = 8'h33;
            d = 8'h44;
            sel = 2'b10;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select Input D (sel=11)", test_num);
            a = 8'hAA;
            b = 8'hBB;
            c = 8'hCC;
            d = 8'hDD;
            sel = 2'b11;
            #1;

            check_outputs(8'hDD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Test - All Inputs High", test_num);
            a = 8'hFF;
            b = 8'hFF;
            c = 8'hFF;
            d = 8'hFF;
            sel = 2'b01;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Test - All Inputs Low", test_num);
            a = 8'h00;
            b = 8'h00;
            c = 8'h00;
            d = 8'h00;
            sel = 2'b10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits Test", test_num);
            a = 8'h55;
            b = 8'hAA;
            c = 8'h0F;
            d = 8'hF0;
            sel = 2'b00;
            #1;

            check_outputs(8'h55);
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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

`timescale 1ns/1ps

module mux4to1_active_high_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg [3:0] in0;
    reg [3:0] in1;
    reg [3:0] in2;
    reg [3:0] in3;
    reg [1:0] sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1_active_high dut (
        .en(en),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            en = 0;
            sel = 2'b00;
            in0 = 4'hA; in1 = 4'h5; in2 = 4'hF; in3 = 4'h0;
            #10;
            $display("Test %0d: Enable=0, Sel=00 - Output should be 0", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            en = 1;
            sel = 2'b00;
            in0 = 4'hA; in1 = 4'h5; in2 = 4'hF; in3 = 4'h0;
            #10;
            $display("Test %0d: Enable=1, Sel=00 - Selecting in0 (4'hA)", test_num);
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            en = 1;
            sel = 2'b01;
            in0 = 4'hA; in1 = 4'h5; in2 = 4'hF; in3 = 4'h0;
            #10;
            $display("Test %0d: Enable=1, Sel=01 - Selecting in1 (4'h5)", test_num);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            en = 1;
            sel = 2'b10;
            in0 = 4'hA; in1 = 4'h5; in2 = 4'hF; in3 = 4'h0;
            #10;
            $display("Test %0d: Enable=1, Sel=10 - Selecting in2 (4'hF)", test_num);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            en = 1;
            sel = 2'b11;
            in0 = 4'hA; in1 = 4'h5; in2 = 4'hF; in3 = 4'h0;
            #10;
            $display("Test %0d: Enable=1, Sel=11 - Selecting in3 (4'h0)", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            en = 0;
            sel = 2'b10;
            in0 = 4'h1; in1 = 4'h2; in2 = 4'h3; in3 = 4'h4;
            #10;
            $display("Test %0d: Enable=0, Sel=10 - Output should be 0 even with non-zero input", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            en = 1;
            sel = 2'b01;
            in0 = 4'h0; in1 = 4'hE; in2 = 4'h0; in3 = 4'h0;
            #10;
            $display("Test %0d: Enable=1, Sel=01 - Selecting in1 (4'hE)", test_num);
            #1;

            check_outputs(4'hE);


            in1 = 4'h7;
            #5;
            $display("Sub-test %0d: Input changed while selected", test_num);
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            en = 1;
            sel = 2'b11;
            in3 = 4'hB;
            #10;
            $display("Test %0d: Enable=1, Sel=11 - Selecting in3 (4'hB)", test_num);
            #1;

            check_outputs(4'hB);

            en = 0;
            #5;
            $display("Sub-test %0d: Disabling while selected", test_num);
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
        $display("mux4to1_active_high Testbench");
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
        input [3:0] expected_out;
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

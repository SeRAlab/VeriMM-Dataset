`timescale 1ns/1ps

module mux4to1_2bit_active_high_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg [1:0] in0;
    reg [1:0] in1;
    reg [1:0] in2;
    reg [1:0] in3;
    reg [1:0] sel;
    wire [1:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1_2bit_active_high dut (
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
            test_num = 1;
            $display("Testcase %0d: Multiplexer disabled (en=0), sel=00", test_num);
            en = 0;
            sel = 2'b00;
            in0 = 2'b11;
            in1 = 2'b10;
            in2 = 2'b01;
            in3 = 2'b00;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Multiplexer enabled (en=1), select in0", test_num);
            en = 1;
            sel = 2'b00;
            in0 = 2'b11;
            in1 = 2'b10;
            in2 = 2'b01;
            in3 = 2'b00;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Multiplexer enabled (en=1), select in1", test_num);
            en = 1;
            sel = 2'b01;
            in0 = 2'b11;
            in1 = 2'b10;
            in2 = 2'b01;
            in3 = 2'b00;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Multiplexer enabled (en=1), select in2", test_num);
            en = 1;
            sel = 2'b10;
            in0 = 2'b11;
            in1 = 2'b10;
            in2 = 2'b01;
            in3 = 2'b00;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Multiplexer enabled (en=1), select in3", test_num);
            en = 1;
            sel = 2'b11;
            in0 = 2'b11;
            in1 = 2'b10;
            in2 = 2'b01;
            in3 = 2'b00;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Multiplexer disabled (en=0), sel=10, inputs non-zero", test_num);
            en = 0;
            sel = 2'b10;
            in0 = 2'b11;
            in1 = 2'b11;
            in2 = 2'b11;
            in3 = 2'b11;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Multiplexer enabled (en=1), check 2-bit values on in1", test_num);
            en = 1;
            sel = 2'b01;
            in0 = 2'b00;
            in1 = 2'b11;
            in2 = 2'b00;
            in3 = 2'b00;
            #1;

            check_outputs(2'b11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4to1_2bit_active_high Testbench");
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
        input [1:0] expected_out;
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

`timescale 1ns/1ps

module ripple_carry_adder_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Clk;
    wire Cout;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ripple_carry_adder dut (
        .A(A),
        .B(B),
        .Clk(Clk),
        .Cout(Cout),
        .S(S)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            A = 4'b0000;
            B = 4'b0000;
            @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Zero addition (0 + 0)", test_num);
            reset_dut();
            A = 4'd0;
            B = 4'd0;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Simple addition without carry (5 + 3)", test_num);
            reset_dut();
            A = 4'd5;
            B = 4'd3;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Internal carries, no output carry (7 + 4)", test_num);
            reset_dut();
            A = 4'd7;
            B = 4'd4;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Sum results in max 4-bit value (10 + 5)", test_num);
            reset_dut();
            A = 4'd10;
            B = 4'd5;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Carry out generation (8 + 8)", test_num);
            reset_dut();
            A = 4'd8;
            B = 4'd8;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Addition with carry out (15 + 1)", test_num);
            reset_dut();
            A = 4'd15;
            B = 4'd1;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Maximum possible sum (15 + 15)", test_num);
            reset_dut();
            A = 4'd15;
            B = 4'd15;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(1'b1, 4'd14);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Alternating bits (10 + 5)", test_num);
            reset_dut();
            A = 4'b1010;
            B = 4'b0101;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b1111);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Carry propagation through all stages (15 + 1)", test_num);
            reset_dut();
            A = 4'b1111;
            B = 4'b0001;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ripple_carry_adder Testbench");
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
        input expected_Cout;
        input [3:0] expected_S;
        begin
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, S=%h",
                         Cout, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, S=%h",
                         expected_Cout, expected_S);
                $display("  Got:      Cout=%b, S=%h",
                         Cout, S);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,A, B, Clk, Cout, S);
    end

endmodule

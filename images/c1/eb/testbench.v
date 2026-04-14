`timescale 1ns/1ps

module adder_4bit_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg B;
    reg Cin;
    reg Clk;
    reg En;
    reg Rst;
    wire Cout;
    wire [3:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_4bit dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Clk(Clk),
        .En(En),
        .Rst(Rst),
        .Cout(Cout),
        .Sum(Sum)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            Cin = 0;
            En = 1;
            Rst = 1;
            @(posedge Clk);
            #1;
            Rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;

            En = 1;
            A = 4'hA;
            B = 4'h5;
            Cin = 0;
            @(posedge Clk);
            #1;

            Rst = 1;
            @(posedge Clk);
            #1;
            $display("Testcase %0d: Synchronous Reset check", test_num);
            #1;

            check_outputs(1'b0, 4'h0);
            Rst = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            A = 4'd7;
            B = 4'd2;
            Cin = 0;
            En = 1;
            @(posedge Clk);
            #1;
            $display("Testcase %0d: Basic Addition (7 + 2)", test_num);
            #1;

            check_outputs(1'b0, 4'd9);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            A = 4'd10;
            B = 4'd3;
            Cin = 1;
            En = 1;
            @(posedge Clk);
            #1;
            $display("Testcase %0d: Addition with Cin (10 + 3 + 1)", test_num);
            #1;

            check_outputs(1'b0, 4'd14);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            A = 4'd12;
            B = 4'd5;
            Cin = 0;
            En = 1;
            @(posedge Clk);
            #1;
            $display("Testcase %0d: Addition with Cout (12 + 5 = 17)", test_num);
            #1;

            check_outputs(1'b1, 4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            A = 4'd4;
            B = 4'd4;
            En = 1;
            @(posedge Clk);
            #1;

            En = 0;
            A = 4'd1;
            B = 4'd1;
            @(posedge Clk);
            #1;
            $display("Testcase %0d: Enable logic (Hold value when En=0)", test_num);
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            A = 4'hF;
            B = 4'hF;
            Cin = 1;
            En = 1;
            @(posedge Clk);
            #1;
            $display("Testcase %0d: Max values (15 + 15 + 1 = 31)", test_num);
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            A = 4'h5;
            B = 4'h5;
            En = 1;
            @(posedge Clk);
            #1;

            En = 0;
            Rst = 1;
            @(posedge Clk);
            #1;
            $display("Testcase %0d: Reset priority over Enable deassertion", test_num);
            #1;

            check_outputs(1'b0, 4'h0);
            Rst = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_4bit Testbench");
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
        input expected_Cout;
        input [3:0] expected_Sum;
        begin
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Sum=%h",
                         Cout, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Sum=%h",
                         expected_Cout, expected_Sum);
                $display("  Got:      Cout=%b, Sum=%h",
                         Cout, Sum);
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
        $dumpvars(0,A, B, Cin, Clk, En, Rst, Cout, Sum);
    end

endmodule

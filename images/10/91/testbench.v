`timescale 1ns/1ps

module neuron_backpropagation_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] B;
    reg [7:0] LR;
    reg [7:0] T;
    reg [7:0] W1;
    reg [7:0] W2;
    reg [7:0] X1;
    reg [7:0] X2;
    reg clk;
    wire [7:0] B_out;
    wire [7:0] O;
    wire [7:0] W1_out;
    wire [7:0] W2_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    neuron_backpropagation dut (
        .B(B),
        .LR(LR),
        .T(T),
        .W1(W1),
        .W2(W2),
        .X1(X1),
        .X2(X2),
        .clk(clk),
        .B_out(B_out),
        .O(O),
        .W1_out(W1_out),
        .W2_out(W2_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            X1 = 8'h00;
            X2 = 8'h00;
            W1 = 8'h00;
            W2 = 8'h00;
            B  = 8'h00;
            LR = 8'h00;
            T  = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %03d: Positive Learning (Target High)", test_num);
            reset_dut();


            X1 = 8'h02;
            X2 = 8'h02;
            W1 = 8'h10;
            W2 = 8'h10;
            B  = 8'h05;
            LR = 8'h02;
            T  = 8'hFF;


            repeat(5) @(posedge clk);
            #2;




            #1;





            check_outputs(8'h0A, 8'h8E, 8'h1A, 8'h1A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %03d: Negative Learning (Target Low)", test_num);
            reset_dut();

            X1 = 8'h04;
            X2 = 8'h04;
            W1 = 8'h40;
            W2 = 8'h40;
            B  = 8'h10;
            LR = 8'h01;
            T  = 8'h00;

            repeat(5) @(posedge clk);
            #2;



            #1;




            check_outputs(8'h0B, 8'h72, 8'h2C, 8'h2C);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %03d: Zero Learning Rate", test_num);
            reset_dut();

            X1 = 8'h0A;
            X2 = 8'h0A;
            W1 = 8'h20;
            W2 = 8'h20;
            B  = 8'h15;
            LR = 8'h00;
            T  = 8'hFF;

            repeat(5) @(posedge clk);
            #2;


            #1;



            check_outputs(8'h15, 8'hB4, 8'h20, 8'h20);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %03d: Zero Inputs (Bias only update)", test_num);
            reset_dut();

            X1 = 8'h00;
            X2 = 8'h00;
            W1 = 8'h15;
            W2 = 8'h15;
            B  = 8'h10;
            LR = 8'h02;
            T  = 8'hFF;

            repeat(5) @(posedge clk);
            #2;


            #1;



            check_outputs(8'h1F, 8'h84, 8'h15, 8'h15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %03d: High Learning Rate", test_num);
            reset_dut();

            X1 = 8'h01;
            X2 = 8'h01;
            W1 = 8'h05;
            W2 = 8'h05;
            B  = 8'h02;
            LR = 8'h20;
            T  = 8'hFF;

            repeat(5) @(posedge clk);
            #2;


            #1;



            check_outputs(8'h42, 8'hF2, 8'h45, 8'h45);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("neuron_backpropagation Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [7:0] expected_B_out;
        input [7:0] expected_O;
        input [7:0] expected_W1_out;
        input [7:0] expected_W2_out;
        begin
            if (expected_B_out === (expected_B_out ^ B_out ^ expected_B_out) &&
                expected_O === (expected_O ^ O ^ expected_O) &&
                expected_W1_out === (expected_W1_out ^ W1_out ^ expected_W1_out) &&
                expected_W2_out === (expected_W2_out ^ W2_out ^ expected_W2_out)) begin
                $display("PASS");
                $display("  Outputs: B_out=%h, O=%h, W1_out=%h, W2_out=%h",
                         B_out, O, W1_out, W2_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B_out=%h, O=%h, W1_out=%h, W2_out=%h",
                         expected_B_out, expected_O, expected_W1_out, expected_W2_out);
                $display("  Got:      B_out=%h, O=%h, W1_out=%h, W2_out=%h",
                         B_out, O, W1_out, W2_out);
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
        $dumpvars(0,B, LR, T, W1, W2, X1, X2, clk, B_out, O, W1_out, W2_out);
    end

endmodule

`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input_data;
    reg [7:0] prev_hidden_state;
    wire [7:0] new_hidden_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .clk(clk),
        .input_data(input_data),
        .prev_hidden_state(prev_hidden_state),
        .new_hidden_state(new_hidden_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            input_data = 8'h00;
            prev_hidden_state = 8'h00;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Zero Inputs", test_num);
            input_data = 8'h00;
            prev_hidden_state = 8'h00;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Positive Input", test_num);
            input_data = 8'h20;
            prev_hidden_state = 8'h00;

            @(posedge clk);
            #2;




            #1;





            check_outputs(8'h15);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Hidden State Feedback", test_num);
            input_data = 8'h00;
            prev_hidden_state = 8'h30;

            @(posedge clk);
            #2;



            #1;




            check_outputs(8'h1F);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Positive Saturation Check", test_num);
            input_data = 8'h7F;
            prev_hidden_state = 8'h7F;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h7F);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Negative Saturation Check", test_num);
            input_data = 8'h80;
            prev_hidden_state = 8'h80;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h80);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Opposing Input and State", test_num);
            input_data = 8'h40;
            prev_hidden_state = 8'hC0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rnn_cell Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [7:0] expected_new_hidden_state;
        begin
            if (expected_new_hidden_state === (expected_new_hidden_state ^ new_hidden_state ^ expected_new_hidden_state)) begin
                $display("PASS");
                $display("  Outputs: new_hidden_state=%h",
                         new_hidden_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_hidden_state=%h",
                         expected_new_hidden_state);
                $display("  Got:      new_hidden_state=%h",
                         new_hidden_state);
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
        $dumpvars(0,clk, input_data, prev_hidden_state, new_hidden_state);
    end

endmodule

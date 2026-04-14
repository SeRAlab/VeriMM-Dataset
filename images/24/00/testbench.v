`timescale 1ns/1ps

module pipo_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg enable;
    reg reset;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipo_shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            data_in = 5'b0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Load (Enable=1, Data=5'h1A)", test_num);
            reset_dut();

            @(negedge clk);
            data_in = 5'h1A;
            enable = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(5'h1A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load Disabled (Enable=0, Data=5'h0F)", test_num);
            reset_dut();

            @(negedge clk);
            data_in = 5'h0F;
            enable = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data Persistence", test_num);
            reset_dut();


            @(negedge clk);
            data_in = 5'h15;
            enable = 1;
            @(posedge clk);


            @(negedge clk);
            enable = 0;
            data_in = 5'h00;


            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max Value Load (5'h1F)", test_num);
            reset_dut();

            @(negedge clk);
            data_in = 5'h1F;
            enable = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Consecutive Loads", test_num);
            reset_dut();

            @(negedge clk);
            enable = 1;
            data_in = 5'h0A;
            @(posedge clk);

            @(negedge clk);
            data_in = 5'h14;
            @(posedge clk);

            #2;
            #1;

            check_outputs(5'h14);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Priority over Enable", test_num);
            reset_dut();

            @(negedge clk);
            enable = 1;
            data_in = 5'h1F;
            reset = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(5'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipo_shift_register Testbench");
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
        input [4:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, enable, reset, data_out);
    end

endmodule

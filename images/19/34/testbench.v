`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 0;

            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        reg [3:0] expected_val;
        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Input 4'h0", test_num);

            data_in = 4'h0;
            expected_val = (4'h0 + 1'b1) & FIXED_MASK;


            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(expected_val);
        end
        endtask

    task testcase002;

        reg [3:0] expected_val;
        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Input 4'h3 (Check AND mask)", test_num);

            data_in = 4'h3;
            expected_val = (4'h3 + 1'b1) & FIXED_MASK;

            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(expected_val);
        end
        endtask

    task testcase003;

        reg [3:0] expected_val;
        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Input 4'hF (Overflow check)", test_num);

            data_in = 4'hF;
            expected_val = (4'hF + 1'b1) & FIXED_MASK;

            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(expected_val);
        end
        endtask

    task testcase004;

        reg [3:0] expected_val;
        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Input 4'hA", test_num);

            data_in = 4'hA;
            expected_val = (4'hA + 1'b1) & FIXED_MASK;

            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(expected_val);
        end
        endtask

    task testcase005;

        reg [3:0] expected_val;
        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Back-to-back stream", test_num);


            data_in = 4'h5;
            @(posedge clk);
            data_in = 4'h6;
            @(posedge clk);
            data_in = 4'h0;



            expected_val = (4'h6 + 1'b1) & FIXED_MASK;

            @(posedge clk);
            #1;

            #1;


            check_outputs(expected_val);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_processor Testbench");
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
        input [3:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, data_out);
    end

endmodule

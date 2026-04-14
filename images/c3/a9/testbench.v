`timescale 1ns/1ps

module register_behavior_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg resetn;
    reg write_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_behavior dut (
        .clk(clk),
        .data_in(data_in),
        .resetn(resetn),
        .write_en(write_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 1'b0;
            write_en = 1'b0;
            data_in = 8'h00;
            @(negedge clk);
            resetn = 1'b1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write and Hold", test_num);
            reset_dut();


            data_in = 8'hAA;
            write_en = 1'b1;
            @(negedge clk);


            write_en = 1'b0;
            data_in = 8'h55;
            @(negedge clk);

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No Write without Enable", test_num);
            reset_dut();


            data_in = 8'hBB;
            write_en = 1'b0;
            @(negedge clk);

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Successive Writes", test_num);
            reset_dut();

            write_en = 1'b1;
            data_in = 8'h11; @(negedge clk);
            data_in = 8'h22; @(negedge clk);
            data_in = 8'h33; @(negedge clk);

            #1;


            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Value Write", test_num);
            reset_dut();


            data_in = 8'hFF;
            write_en = 1'b1;
            @(negedge clk);


            data_in = 8'h00;
            @(negedge clk);

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset During Operation", test_num);
            reset_dut();


            data_in = 8'hCC;
            write_en = 1'b1;
            @(negedge clk);


            resetn = 1'b0;
            @(negedge clk);
            resetn = 1'b1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Bits High", test_num);
            reset_dut();

            data_in = 8'hFF;
            write_en = 1'b1;
            @(negedge clk);

            #1;


            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_behavior Testbench");
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, resetn, write_en, data_out);
    end

endmodule

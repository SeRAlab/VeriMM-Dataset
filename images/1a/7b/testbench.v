`timescale 1ns/1ps

module flash_memory_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg [7:0] data_in;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory_cell dut (
        .clk(clk),
        .control(control),
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
            @(posedge clk);
            control <= 0;
            data_in <= 8'h00;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Read (8'hA5)");
            reset_dut();
            test_num = test_num + 1;


            @(posedge clk);
            control <= 1;
            data_in <= 8'hA5;
            @(posedge clk);


            control <= 0;
            data_in <= 8'h00;
            @(posedge clk);

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Data Persistence");
            reset_dut();
            test_num = test_num + 1;


            @(posedge clk);
            control <= 1;
            data_in <= 8'h5A;
            @(posedge clk);


            control <= 0;
            data_in <= 8'hFF;
            @(posedge clk);
            data_in <= 8'h00;
            @(posedge clk);
            data_in <= 8'h33;
            @(posedge clk);

            #1;


            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Overwriting Stored Value");
            reset_dut();
            test_num = test_num + 1;


            @(posedge clk);
            control <= 1;
            data_in <= 8'h11;
            @(posedge clk);


            control <= 1;
            data_in <= 8'h22;
            @(posedge clk);


            control <= 0;
            @(posedge clk);

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Boundary Test (All Zeros)");
            reset_dut();
            test_num = test_num + 1;


            @(posedge clk);
            control <= 1;
            data_in <= 8'h00;
            @(posedge clk);


            control <= 0;
            data_in <= 8'hFF;
            @(posedge clk);

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Boundary Test (All Ones)");
            reset_dut();
            test_num = test_num + 1;


            @(posedge clk);
            control <= 1;
            data_in <= 8'hFF;
            @(posedge clk);


            control <= 0;
            data_in <= 8'h00;
            @(posedge clk);

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
        $display("flash_memory_cell Testbench");
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
        $dumpvars(0,clk, control, data_in, data_out);
    end

endmodule

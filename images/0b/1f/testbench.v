`timescale 1ns/1ps

module cache_controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] data_in;
    reg [1:0] index;
    reg read_write;
    wire [7:0] data_out;
    wire [3:0] replace_line;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cache_controller dut (
        .data_in(data_in),
        .index(index),
        .read_write(read_write),
        .data_out(data_out),
        .replace_line(replace_line)
    );

    // Clock generation (10ns period)
    initial begin
        read_write = 0;
        forever #5 read_write = ~read_write;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_in = 0;
            index = 0;
            read_write = 0;
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential Fill", test_num);
            reset_dut();


            index = 2'b00; data_in = 8'hAA; read_write = 1; @(posedge clk);

            index = 2'b01; data_in = 8'hBB; read_write = 1; @(posedge clk);

            index = 2'b10; data_in = 8'hCC; read_write = 1; @(posedge clk);

            index = 2'b11; data_in = 8'hDD; read_write = 1; @(posedge clk);

            #2;
            #1;

            check_outputs(8'hDD, 4'b1000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Read After Write", test_num);
            reset_dut();


            index = 2'b10; data_in = 8'h55; read_write = 1; @(posedge clk);


            index = 2'b10; read_write = 0; @(posedge clk);

            #2;
            #1;

            check_outputs(8'h55, 4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Overwrite", test_num);
            reset_dut();


            index = 2'b01; data_in = 8'h11; read_write = 1; @(posedge clk);

            index = 2'b01; data_in = 8'hFF; read_write = 1; @(posedge clk);

            #2;
            #1;

            check_outputs(8'hFF, 4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multi-line Data Integrity", test_num);
            reset_dut();


            index = 2'b00; data_in = 8'h01; read_write = 1; @(posedge clk);
            index = 2'b01; data_in = 8'h02; read_write = 1; @(posedge clk);


            index = 2'b00; read_write = 0; @(posedge clk);
            #2;
            if (data_out !== 8'h01) $display("Error reading line 0");


            index = 2'b01; read_write = 0; @(posedge clk);
            #2;
            #1;

            check_outputs(8'h02, 4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cache_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [3:0] expected_replace_line;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_replace_line === (expected_replace_line ^ replace_line ^ expected_replace_line)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, replace_line=%h",
                         data_out, replace_line);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, replace_line=%h",
                         expected_data_out, expected_replace_line);
                $display("  Got:      data_out=%h, replace_line=%h",
                         data_out, replace_line);
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
        $dumpvars(0,data_in, index, read_write, data_out, replace_line);
    end

endmodule

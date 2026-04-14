`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] input_data;
    reg read_enable;
    reg write_enable;
    wire [3:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .clk(clk),
        .input_data(input_data),
        .read_enable(read_enable),
        .write_enable(write_enable),
        .output_data(output_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            write_enable = 0;
            read_enable = 0;
            input_data = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write and Read (Write 0xA)", test_num);
            reset_dut();


            @(negedge clk);
            write_enable = 1;
            input_data = 4'hA;
            @(negedge clk);
            write_enable = 0;


            read_enable = 1;
            @(negedge clk);
            read_enable = 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overwriting data (0x5 then 0xC)", test_num);
            reset_dut();


            @(negedge clk);
            write_enable = 1;
            input_data = 4'h5;
            @(negedge clk);


            input_data = 4'hC;
            @(negedge clk);
            write_enable = 0;


            read_enable = 1;
            @(negedge clk);
            read_enable = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Enable check (No write when WE=0)", test_num);
            reset_dut();


            @(negedge clk);
            write_enable = 1;
            input_data = 4'h3;
            @(negedge clk);


            write_enable = 0;
            input_data = 4'hF;
            @(negedge clk);


            read_enable = 1;
            @(negedge clk);
            read_enable = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write/Read 0xF", test_num);
            reset_dut();

            @(negedge clk);
            write_enable = 1;
            input_data = 4'hF;
            @(negedge clk);
            write_enable = 0;

            read_enable = 1;
            @(negedge clk);
            read_enable = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write/Read 0x0", test_num);
            reset_dut();


            @(negedge clk);
            write_enable = 1;
            input_data = 4'h7;
            @(negedge clk);


            input_data = 4'h0;
            @(negedge clk);
            write_enable = 0;

            read_enable = 1;
            @(negedge clk);
            read_enable = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        input [3:0] expected_output_data;
        begin
            if (expected_output_data === (expected_output_data ^ output_data ^ expected_output_data)) begin
                $display("PASS");
                $display("  Outputs: output_data=%h",
                         output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_data=%h",
                         expected_output_data);
                $display("  Got:      output_data=%h",
                         output_data);
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
        $dumpvars(0,clk, input_data, read_enable, write_enable, output_data);
    end

endmodule

`timescale 1ns/1ps

module FlashMemoryCellController_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg erase_en;
    reg read_en;
    reg reset;
    reg write_en;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    FlashMemoryCellController dut (
        .clk(clk),
        .data_in(data_in),
        .erase_en(erase_en),
        .read_en(read_en),
        .reset(reset),
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
            reset = 1;
            data_in = 0;
            erase_en = 0;
            read_en = 0;
            write_en = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initialization Check", test_num);
            reset_dut();
            read_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Program (Write 1) and Read", test_num);
            reset_dut();

            write_en = 1;
            data_in = 1;
            @(posedge clk);
            #1 write_en = 0;

            read_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Erase Operation", test_num);
            reset_dut();

            write_en = 1;
            data_in = 1;
            @(posedge clk);
            #1 write_en = 0;

            erase_en = 1;
            @(posedge clk);
            #1 erase_en = 0;

            read_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Write 0 Operation", test_num);
            reset_dut();

            write_en = 1;
            data_in = 1;
            @(posedge clk);

            data_in = 0;
            @(posedge clk);
            #1 write_en = 0;

            read_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Read Disable Check", test_num);
            reset_dut();

            write_en = 1;
            data_in = 1;
            @(posedge clk);
            #1 write_en = 0;

            read_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("FlashMemoryCellController Testbench");
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
        input expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b",
                         expected_data_out);
                $display("  Got:      data_out=%b",
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
        $dumpvars(0,clk, data_in, erase_en, read_en, reset, write_en, data_out);
    end

endmodule

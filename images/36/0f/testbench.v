`timescale 1ns/1ps

module sd_card_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg write_enable;
    wire write_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_controller dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .write_enable(write_enable),
        .write_done(write_done)
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
            write_enable = 0;
            #20;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic single byte write", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'hA5;
            write_enable = 1;

            @(posedge clk);
            write_enable = 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No write when write_enable is low", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'h5A;
            write_enable = 0;

            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive writes", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'h11;
            write_enable = 1;

            @(posedge clk);
            data_in = 8'h22;
            write_enable = 1;


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write after idle period", test_num);
            reset_dut();

            repeat(5) @(posedge clk);

            data_in = 8'hFF;
            write_enable = 1;
            @(posedge clk);
            write_enable = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: write_done pulse duration check", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'hCC;
            write_enable = 1;
            @(posedge clk);
            write_enable = 0;

            @(posedge clk);
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
        $display("sd_card_controller Testbench");
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
        input expected_write_done;
        begin
            if (expected_write_done === (expected_write_done ^ write_done ^ expected_write_done)) begin
                $display("PASS");
                $display("  Outputs: write_done=%b",
                         write_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: write_done=%b",
                         expected_write_done);
                $display("  Got:      write_done=%b",
                         write_done);
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
        $dumpvars(0,clk, data_in, reset, write_enable, write_done);
    end

endmodule

`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
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
            data_in <= 1'b0;

            repeat(5) @(posedge clk);
            $display("System reset/stabilized.");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Input '1' - Expect '1' after 2 cycles", test_num);
            reset_dut();
            @(posedge clk);
            data_in <= 1'b1;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Input '0' - Expect '0' after 2 cycles", test_num);
            reset_dut();

            @(posedge clk);
            data_in <= 1'b1;
            @(posedge clk);
            data_in <= 1'b0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Sequence 1-0-1 - Check middle bit", test_num);
            reset_dut();
            @(posedge clk);
            data_in <= 1'b1;
            @(posedge clk);
            data_in <= 1'b0;
            @(posedge clk);
            data_in <= 1'b1;


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Stream logic - Sustained High", test_num);
            reset_dut();
            @(posedge clk);
            data_in <= 1'b1;
            @(posedge clk);
            data_in <= 1'b1;
            @(posedge clk);
            data_in <= 1'b1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Toggle check", test_num);
            reset_dut();
            @(posedge clk);
            data_in <= 1'b1;
            @(posedge clk);
            data_in <= 1'b0;
            @(posedge clk);
            data_in <= 1'b1;
            @(posedge clk);
            data_in <= 1'b0;

            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        $dumpvars(0,clk, data_in, data_out);
    end

endmodule

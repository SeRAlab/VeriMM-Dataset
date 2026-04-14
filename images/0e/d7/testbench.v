`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] input_data;
    reg read_en;
    reg reset;
    reg write_en;
    wire [7:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .input_data(input_data),
        .read_en(read_en),
        .reset(reset),
        .write_en(write_en),
        .output_data(output_data)
    );

    // Clock generation (10ns period)
    initial begin
        read_en = 0;
        forever #5 read_en = ~read_en;
    end

        task reset_dut;

        begin
            reset = 1;
            write_en = 0;
            input_data = 8'h00;
            #10;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Verification", test_num);
            reset_dut();

            wait(read_en == 1);
            #1;

            check_outputs(8'h00);
            #5;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (0xAA)", test_num);
            reset_dut();

            input_data = 8'hAA;
            write_en = 1;
            #10;
            write_en = 0;

            wait(read_en == 1);
            #1;

            check_outputs(8'hAA);
            #5;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (0x55)", test_num);
            reset_dut();

            input_data = 8'h55;
            write_en = 1;
            #10;
            write_en = 0;

            wait(read_en == 1);
            #1;

            check_outputs(8'h55);
            #5;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Low Check", test_num);
            reset_dut();


            input_data = 8'h11;
            write_en = 1;
            #10;


            input_data = 8'hEE;
            write_en = 0;
            #10;

            wait(read_en == 1);
            #1;

            check_outputs(8'h11);
            #5;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Scale Write (0xFF)", test_num);
            reset_dut();

            input_data = 8'hFF;
            write_en = 1;
            #10;
            write_en = 0;

            wait(read_en == 1);
            #1;

            check_outputs(8'hFF);
            #5;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Override", test_num);
            reset_dut();

            input_data = 8'h77;
            write_en = 1;
            #10;

            reset = 1;
            #10;
            reset = 0;
            write_en = 0;

            wait(read_en == 1);
            #1;

            check_outputs(8'h00);
            #5;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gpio_controller Testbench");
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
        input [7:0] expected_output_data;
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
        $dumpvars(0,input_data, read_en, reset, write_en, output_data);
    end

endmodule

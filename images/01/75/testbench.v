`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg read_enable;
    reg [4:0] write_data;
    wire [4:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .enable(enable),
        .read_enable(read_enable),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        enable = 0;
        read_enable = 0;
        write_data = 0;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("\nTestcase %0d: Basic Write and Read", test_num);


        write_data = 5'h15;
        enable = 1;
        @(posedge clk);
        #1 enable = 0;


        read_enable = 1;
        #2;
        #1;

        check_outputs(5'h15);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("\nTestcase %0d: Write Enable Gating (should not change)", test_num);


        write_data = 5'h0A;
        enable = 1;
        @(posedge clk);
        #1 enable = 0;


        write_data = 5'h1F;
        enable = 0;
        @(posedge clk);
        #1;


        read_enable = 1;
        #2;
        #1;

        check_outputs(5'h0A);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("\nTestcase %0d: Testing All Pins High (0x1F)", test_num);

        write_data = 5'h1F;
        enable = 1;
        @(posedge clk);
        #1 enable = 0;

        read_enable = 1;
        #2;
        #1;

        check_outputs(5'h1F);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("\nTestcase %0d: Consecutive Writes", test_num);


        write_data = 5'h01;
        enable = 1;
        @(posedge clk);


        write_data = 5'h10;
        @(posedge clk);
        #1 enable = 0;

        read_enable = 1;
        #2;
        #1;

        check_outputs(5'h10);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("\nTestcase %0d: Read Enable Logic (Disabled Read)", test_num);

        write_data = 5'h12;
        enable = 1;
        @(posedge clk);
        #1 enable = 0;

        read_enable = 0;
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
        $display("gpio_controller Testbench");
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
        input [4:0] expected_read_data;
        begin
            if (expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: read_data=%h",
                         read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data=%h",
                         expected_read_data);
                $display("  Got:      read_data=%h",
                         read_data);
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
        $dumpvars(0,clk, enable, read_enable, write_data, read_data);
    end

endmodule

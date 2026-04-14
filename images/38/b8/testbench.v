`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rx_enable;
    reg [7:0] tx_data;
    reg tx_enable;
    wire [7:0] rx_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .rx_enable(rx_enable),
        .tx_data(tx_data),
        .tx_enable(tx_enable),
        .rx_data(rx_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            tx_enable = 0;
            rx_enable = 0;
            tx_data = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Byte Transmit and Receive (0xAA)", test_num);
            reset_dut();


            tx_enable = 1;
            tx_data = 8'hAA;
            @(posedge clk);
            #1;
            tx_enable = 0;


            rx_enable = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hAA);
            rx_enable = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Byte Transmit and Receive (0x55)", test_num);
            reset_dut();


            tx_enable = 1;
            tx_data = 8'h55;
            @(posedge clk);
            #1;
            tx_enable = 0;


            rx_enable = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h55);
            rx_enable = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: tx_enable Low Check (Data should not be stored)", test_num);
            reset_dut();


            tx_enable = 0;
            tx_data = 8'hFF;
            @(posedge clk);
            #1;


            rx_enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
            rx_enable = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: rx_enable Low Check (Output should not show buffer)", test_num);
            reset_dut();


            tx_enable = 1;
            tx_data = 8'hBC;
            @(posedge clk);
            #1;
            tx_enable = 0;


            rx_enable = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overwrite Buffer Test", test_num);
            reset_dut();


            tx_enable = 1;
            tx_data = 8'h11;
            @(posedge clk);
            #1;


            tx_data = 8'h22;
            @(posedge clk);
            #1;
            tx_enable = 0;


            rx_enable = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h22);
            rx_enable = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Value Test (0xFF)", test_num);
            reset_dut();

            tx_enable = 1;
            tx_data = 8'hFF;
            @(posedge clk);
            #1;
            tx_enable = 0;

            rx_enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF);
            rx_enable = 0;
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
        input [7:0] expected_rx_data;
        begin
            if (expected_rx_data === (expected_rx_data ^ rx_data ^ expected_rx_data)) begin
                $display("PASS");
                $display("  Outputs: rx_data=%h",
                         rx_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx_data=%h",
                         expected_rx_data);
                $display("  Got:      rx_data=%h",
                         rx_data);
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
        $dumpvars(0,clk, rx_enable, tx_data, tx_enable, rx_data);
    end

endmodule

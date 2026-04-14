`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg filter_enable;
    reg [31:0] packet;
    reg rst;
    wire packet_accepted;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .clk(clk),
        .filter_enable(filter_enable),
        .packet(packet),
        .rst(rst),
        .packet_accepted(packet_accepted)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            filter_enable = 0;
            packet = 32'h0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Valid Packet Header (0xAB) with Filter Enabled", test_num);
            reset_dut();
            packet = 32'hAB_12_34_56;
            filter_enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Invalid Packet Header (0xCD) with Filter Enabled", test_num);
            reset_dut();
            packet = 32'hCD_88_99_00;
            filter_enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Valid Packet Header (0xAB) with Filter Disabled", test_num);
            reset_dut();
            packet = 32'hAB_FF_FF_FF;
            filter_enable = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: 0xAB in middle bits (Invalid Position)", test_num);
            reset_dut();
            packet = 32'h00_AB_00_00;
            filter_enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Boundary Case - 0xAB followed by zeros", test_num);
            reset_dut();
            packet = 32'hAB_00_00_00;
            filter_enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Output during Reset", test_num);
            rst = 1;
            packet = 32'hAB_11_22_33;
            filter_enable = 1;
            #10;
            #1;

            check_outputs(1'b0);
            rst = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("packet_filter Testbench");
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
        input expected_packet_accepted;
        begin
            if (expected_packet_accepted === (expected_packet_accepted ^ packet_accepted ^ expected_packet_accepted)) begin
                $display("PASS");
                $display("  Outputs: packet_accepted=%b",
                         packet_accepted);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packet_accepted=%b",
                         expected_packet_accepted);
                $display("  Got:      packet_accepted=%b",
                         packet_accepted);
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
        $dumpvars(0,clk, filter_enable, packet, rst, packet_accepted);
    end

endmodule

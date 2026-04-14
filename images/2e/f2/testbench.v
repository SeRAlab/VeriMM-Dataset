`timescale 1ns/1ps

module bluetooth_packet_handler_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] packet_type;
    reg rst;
    reg valid;
    wire [4:0] stored_packet;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_packet_handler dut (
        .clk(clk),
        .packet_type(packet_type),
        .rst(rst),
        .valid(valid),
        .stored_packet(stored_packet)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            packet_type = 5'b0;
            valid = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Power-on Reset", test_num);
            reset_dut();
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load Valid Packet (5'h0A)", test_num);
            reset_dut();
            packet_type = 5'h0A;
            valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Retain Value on Invalid", test_num);
            reset_dut();


            packet_type = 5'h15;
            valid = 1;
            @(posedge clk);


            #1 packet_type = 5'h0F;
            valid = 0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Consecutive Updates", test_num);
            reset_dut();

            packet_type = 5'h01; valid = 1; @(posedge clk);
            #1 packet_type = 5'h02; valid = 1; @(posedge clk);
            #1 packet_type = 5'h03; valid = 1; @(posedge clk);
            #1 packet_type = 5'h04; valid = 1; @(posedge clk);

            #1;
            #1;

            check_outputs(5'h04);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Value Load (5'h1F)", test_num);
            reset_dut();

            packet_type = 5'h1F;
            valid = 1;
            @(posedge clk);

            #1;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Value Load", test_num);
            reset_dut();


            packet_type = 5'h1F; valid = 1; @(posedge clk);

            #1 packet_type = 5'h00; valid = 1; @(posedge clk);

            #1;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Extended Persistence", test_num);
            reset_dut();

            packet_type = 5'h12;
            valid = 1;
            @(posedge clk);

            #1 valid = 0;
            for (i = 0; i < 10; i = i + 1) begin
                packet_type = i[4:0];
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(5'h12);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bluetooth_packet_handler Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [4:0] expected_stored_packet;
        begin
            if (expected_stored_packet === (expected_stored_packet ^ stored_packet ^ expected_stored_packet)) begin
                $display("PASS");
                $display("  Outputs: stored_packet=%h",
                         stored_packet);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stored_packet=%h",
                         expected_stored_packet);
                $display("  Got:      stored_packet=%h",
                         stored_packet);
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
        $dumpvars(0,clk, packet_type, rst, valid, stored_packet);
    end

endmodule

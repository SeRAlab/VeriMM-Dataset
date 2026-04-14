`timescale 1ns/1ps

module pcie_packet_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] packet_in;
    reg reset;
    wire valid_packet;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_packet_processor dut (
        .clk(clk),
        .packet_in(packet_in),
        .reset(reset),
        .valid_packet(valid_packet)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            packet_in = 8'h00;
            repeat (2) @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Valid Packet (Start -> Data -> End)", test_num);
            reset_dut();

            packet_in = START_SEQ; @(negedge clk);
            packet_in = DATA_VAL;  @(negedge clk);
            packet_in = END_SEQ;   @(negedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Incomplete Packet (Start -> Data -> No End)", test_num);
            reset_dut();

            packet_in = START_SEQ; @(negedge clk);
            packet_in = DATA_VAL;  @(negedge clk);
            packet_in = 8'hEE;     @(negedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Invalid Start (Random -> End)", test_num);
            reset_dut();

            packet_in = 8'h12;     @(negedge clk);
            packet_in = DATA_VAL;  @(negedge clk);
            packet_in = END_SEQ;   @(negedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Reset during packet transmission", test_num);
            reset_dut();

            packet_in = START_SEQ; @(negedge clk);
            packet_in = DATA_VAL;  @(negedge clk);


            reset = 1; @(negedge clk);
            reset = 0;

            packet_in = END_SEQ;   @(negedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Two consecutive valid packets", test_num);
            reset_dut();


            packet_in = START_SEQ; @(negedge clk);
            packet_in = END_SEQ;   @(negedge clk);


            packet_in = START_SEQ; @(negedge clk);
            packet_in = 8'hCC;     @(negedge clk);
            packet_in = END_SEQ;   @(negedge clk);

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
        $display("pcie_packet_processor Testbench");
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
        input expected_valid_packet;
        begin
            if (expected_valid_packet === (expected_valid_packet ^ valid_packet ^ expected_valid_packet)) begin
                $display("PASS");
                $display("  Outputs: valid_packet=%b",
                         valid_packet);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid_packet=%b",
                         expected_valid_packet);
                $display("  Got:      valid_packet=%b",
                         valid_packet);
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
        $dumpvars(0,clk, packet_in, reset, valid_packet);
    end

endmodule

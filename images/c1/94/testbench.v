`timescale 1ns/1ps

module LED_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] IP;
    reg Read;
    reg Write;
    reg clock;
    reg [14:0] dataIn;
    reg reset;
    wire Ack;
    wire [13:0] LED;
    wire [13:0] dataOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LED dut (
        .IP(IP),
        .Read(Read),
        .Write(Write),
        .clock(clock),
        .dataIn(dataIn),
        .reset(reset),
        .Ack(Ack),
        .LED(LED),
        .dataOut(dataOut)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            IP = 0;
            Read = 0;
            Write = 0;
            dataIn = 0;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0, 14'h0000, 14'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            dataIn = 15'h2AAA;
            Write = 1;
            @(posedge clock);
            #1 Write = 0;

            #1;


            check_outputs(1'b1, 14'h2AAA, 14'h2AAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            IP = 8'h55;
            dataIn = 15'h4BBB;
            Write = 1;
            @(posedge clock);
            #1 Write = 0;

            #1;


            check_outputs(1'b1, 14'h0055, 14'h0BBB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            Read = 1;
            @(posedge clock);
            #1 Read = 0;

            #1;


            check_outputs(1'b1, 14'h0000, 14'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            dataIn = 15'h0FFF;
            Write = 1;
            @(posedge clock);

            dataIn = 15'h4001;
            IP = 8'hFF;
            @(posedge clock);
            #1 Write = 0;

            #1;


            check_outputs(1'b1, 14'h00FF, 14'h0001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            dataIn = 15'h1234;
            Write = 1;
            @(posedge clock);
            #1 Write = 0;
            @(posedge clock);
            @(posedge clock);

            #1;


            check_outputs(1'b0, 14'h1234, 14'h1234);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LED Testbench");
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
        input expected_Ack;
        input [13:0] expected_LED;
        input [13:0] expected_dataOut;
        begin
            if (expected_Ack === (expected_Ack ^ Ack ^ expected_Ack) &&
                expected_LED === (expected_LED ^ LED ^ expected_LED) &&
                expected_dataOut === (expected_dataOut ^ dataOut ^ expected_dataOut)) begin
                $display("PASS");
                $display("  Outputs: Ack=%b, LED=%h, dataOut=%h",
                         Ack, LED, dataOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Ack=%b, LED=%h, dataOut=%h",
                         expected_Ack, expected_LED, expected_dataOut);
                $display("  Got:      Ack=%b, LED=%h, dataOut=%h",
                         Ack, LED, dataOut);
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
        $dumpvars(0,IP, Read, Write, clock, dataIn, reset, Ack, LED, dataOut);
    end

endmodule

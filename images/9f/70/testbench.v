`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg EndofNote;
    reg [3:0] KeyOutput;
    reg Reset;
    reg Start;
    reg [4:0] StartAddress;
    wire [4:0] CurrentAddress;
    wire EndofScore;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .EndofNote(EndofNote),
        .KeyOutput(KeyOutput),
        .Reset(Reset),
        .Start(Start),
        .StartAddress(StartAddress),
        .CurrentAddress(CurrentAddress),
        .EndofScore(EndofScore)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            Reset = 1;
            Start = 0;
            EndofNote = 0;
            KeyOutput = 0;
            StartAddress = 0;
            @(posedge Clock);
            #1 Reset = 0;
            @(posedge Clock);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Start and Initialization", test_num);
            reset_dut();

            StartAddress = 5'h0A;
            KeyOutput = 4'h1;
            Start = 1;
            @(posedge Clock);
            #1 Start = 0;

            @(posedge Clock);

            #1;


            check_outputs(5'h0A, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Address Incrementing", test_num);
            reset_dut();

            StartAddress = 5'h05;
            KeyOutput = 4'h2;
            Start = 1;
            @(posedge Clock);
            #1 Start = 0;


            repeat(3) begin
                @(posedge Clock);
                EndofNote = 1;
                @(posedge Clock);
                #1 EndofNote = 0;
            end


            #1;



            check_outputs(5'h08, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key Released Reset", test_num);
            reset_dut();

            StartAddress = 5'h10;
            KeyOutput = 4'h5;
            Start = 1;
            @(posedge Clock);
            #1 Start = 0;

            @(posedge Clock);
            EndofNote = 1;
            @(posedge Clock);
            #1 EndofNote = 0;

            @(posedge Clock);
            KeyOutput = 4'h0;
            @(posedge Clock);




            #1;





            check_outputs(5'h00, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Restart sequence", test_num);
            reset_dut();

            StartAddress = 5'h1F;
            KeyOutput = 4'hA;
            Start = 1;
            @(posedge Clock);
            #1 Start = 0;


            #1;



            check_outputs(5'h1F, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reaching end of address range", test_num);
            reset_dut();

            StartAddress = 5'h1E;
            KeyOutput = 4'hF;
            Start = 1;
            @(posedge Clock);
            #1 Start = 0;


            repeat(2) begin
                @(posedge Clock);
                EndofNote = 1;
                @(posedge Clock);
                #1 EndofNote = 0;
            end



            #1;




            check_outputs(5'h00, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [4:0] expected_CurrentAddress;
        input expected_EndofScore;
        begin
            if (expected_CurrentAddress === (expected_CurrentAddress ^ CurrentAddress ^ expected_CurrentAddress) &&
                expected_EndofScore === (expected_EndofScore ^ EndofScore ^ expected_EndofScore)) begin
                $display("PASS");
                $display("  Outputs: CurrentAddress=%h, EndofScore=%b",
                         CurrentAddress, EndofScore);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CurrentAddress=%h, EndofScore=%b",
                         expected_CurrentAddress, expected_EndofScore);
                $display("  Got:      CurrentAddress=%h, EndofScore=%b",
                         CurrentAddress, EndofScore);
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
        $dumpvars(0,Clock, EndofNote, KeyOutput, Reset, Start, StartAddress, CurrentAddress, EndofScore);
    end

endmodule

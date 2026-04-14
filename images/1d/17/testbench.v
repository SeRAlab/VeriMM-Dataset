`timescale 1ns/1ps

module serializer_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] parallel_in;
    reg reset;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer_16bit dut (
        .clk(clk),
        .parallel_in(parallel_in),
        .reset(reset),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: MSB shift out check (Bit 15)", test_num);
        parallel_in = 16'h8000;
        reset_dut();


        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: MSB shift out check (Bit 15 = 0)", test_num);
        parallel_in = 16'h7FFF;
        reset_dut();
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Bit 14 check", test_num);
        parallel_in = 16'h4000;
        reset_dut();
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

        integer i;
    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: LSB check (Bit 0)", test_num);
        parallel_in = 16'h0001;
        reset_dut();
        for (i = 0; i < 15; i = i + 1) begin
            @(posedge clk);
        end
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

        integer i;
    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Persistence check (Hold bit 0)", test_num);
        parallel_in = 16'h0001;
        reset_dut();

        for (i = 0; i < 25; i = i + 1) begin
            @(posedge clk);
        end
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

        integer i;
    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Persistence check (Hold bit 0 = 0)", test_num);
        parallel_in = 16'hFFFE;
        reset_dut();
        for (i = 0; i < 20; i = i + 1) begin
            @(posedge clk);
        end
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

        integer i;
    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Middle bit check (Bit 8)", test_num);
        parallel_in = 16'h0100;
        reset_dut();

        for (i = 0; i < 7; i = i + 1) begin
            @(posedge clk);
        end
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

        integer i;
    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Pattern check (Bit 4 of AAAA)", test_num);
        parallel_in = 16'hAAAA;
        reset_dut();

        for (i = 0; i < 11; i = i + 1) begin
            @(posedge clk);
        end
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
        $display("serializer_16bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_serial_out;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%b",
                         serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%b",
                         expected_serial_out);
                $display("  Got:      serial_out=%b",
                         serial_out);
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
        $dumpvars(0,clk, parallel_in, reset, serial_out);
    end

endmodule

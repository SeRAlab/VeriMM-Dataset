`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg MISO;
    reg clk;
    reg reset;
    reg start;
    wire CS;
    wire MOSI;
    wire SCLK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .MISO(MISO),
        .clk(clk),
        .reset(reset),
        .start(start),
        .CS(CS),
        .MOSI(MOSI),
        .SCLK(SCLK)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        start = 0;
        MISO = 0;
        #20;
        reset = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Initial state after reset", test_num);
        reset_dut();

        #1;


        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single 8-bit transaction", test_num);
        reset_dut();

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;



        wait(CS == 1'b0);
        wait(CS == 1'b1);

        repeat(5) @(posedge clk);

        #1;


        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Back-to-back transactions", test_num);
        reset_dut();


        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;
        wait(CS == 1'b1);

        repeat(2) @(posedge clk);


        start = 1;
        @(posedge clk);
        start = 0;
        wait(CS == 1'b1);

        repeat(5) @(posedge clk);

        #1;


        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Transaction with MISO activity", test_num);
        reset_dut();

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;



        fork
            begin
                for(i=0; i<8; i=i+1) begin
                    @(posedge SCLK);
                    MISO = i[0];
                    @(negedge SCLK);
                end
                MISO = 0;
            end
            begin
                wait(CS == 1'b0);
                wait(CS == 1'b1);
            end
        join

        repeat(5) @(posedge clk);

        #1;


        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    integer sclk_count;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify SCLK pulse count", test_num);
        reset_dut();
        sclk_count = 0;

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;


        while (CS == 1'b0) begin
            @(posedge SCLK);
            if (CS == 1'b0) sclk_count = sclk_count + 1;

            if (sclk_count > 16) break;
        end

        repeat(5) @(posedge clk);


        if (sclk_count == 8) begin
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end else begin
            $display("FAIL: Expected 8 SCLK pulses, got %0d", sclk_count);
            fail_count = fail_count + 1;
        end
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spi_controller Testbench");
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
        input expected_CS;
        input expected_MOSI;
        input expected_SCLK;
        begin
            if (expected_CS === (expected_CS ^ CS ^ expected_CS) &&
                expected_MOSI === (expected_MOSI ^ MOSI ^ expected_MOSI) &&
                expected_SCLK === (expected_SCLK ^ SCLK ^ expected_SCLK)) begin
                $display("PASS");
                $display("  Outputs: CS=%b, MOSI=%b, SCLK=%b",
                         CS, MOSI, SCLK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CS=%b, MOSI=%b, SCLK=%b",
                         expected_CS, expected_MOSI, expected_SCLK);
                $display("  Got:      CS=%b, MOSI=%b, SCLK=%b",
                         CS, MOSI, SCLK);
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
        $dumpvars(0,MISO, clk, reset, start, CS, MOSI, SCLK);
    end

endmodule

`timescale 1ns/1ps

module spi_master_tb;

    // Testbench signals (sequential circuit)
    reg SCK_EN;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire CS;
    wire MOSI;
    wire SCK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_master dut (
        .SCK_EN(SCK_EN),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .CS(CS),
        .MOSI(MOSI),
        .SCK(SCK)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        SCK_EN = 0;
        data_in = 8'h0;
        repeat(2) @(posedge clk);
        #1 reset = 0;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Transmit 0xA5", test_num);
        reset_dut();
        data_in = 8'hA5;
        SCK_EN = 1;

        repeat(25) @(posedge clk);
        SCK_EN = 0;
        repeat(2) @(posedge clk);


        #1;



        check_outputs(1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Transmit 0x50", test_num);
        reset_dut();
        data_in = 8'h50;
        SCK_EN = 1;
        repeat(25) @(posedge clk);
        SCK_EN = 0;
        repeat(2) @(posedge clk);


        #1;



        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verify Idle when SCK_EN is low", test_num);
        reset_dut();
        data_in = 8'hFF;
        SCK_EN = 0;
        repeat(20) @(posedge clk);

        #1;


        check_outputs(1'b1, MOSI, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset mid-transmission", test_num);
        reset_dut();
        data_in = 8'hAA;
        SCK_EN = 1;
        repeat(5) @(posedge clk);
        reset = 1;
        #15;
        reset = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(1'b1, MOSI, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spi_master Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_SCK;
        begin
            if (expected_CS === (expected_CS ^ CS ^ expected_CS) &&
                expected_MOSI === (expected_MOSI ^ MOSI ^ expected_MOSI) &&
                expected_SCK === (expected_SCK ^ SCK ^ expected_SCK)) begin
                $display("PASS");
                $display("  Outputs: CS=%b, MOSI=%b, SCK=%b",
                         CS, MOSI, SCK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CS=%b, MOSI=%b, SCK=%b",
                         expected_CS, expected_MOSI, expected_SCK);
                $display("  Got:      CS=%b, MOSI=%b, SCK=%b",
                         CS, MOSI, SCK);
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
        $dumpvars(0,SCK_EN, clk, data_in, reset, CS, MOSI, SCK);
    end

endmodule

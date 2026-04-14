`timescale 1ns/1ps

module shift_reg_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg si;
    wire [7:0] po;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_8bit dut (
        .clk(clk),
        .rst(rst),
        .si(si),
        .po(po)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            si = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] data_to_shift;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift in 0xAA (10101010)", test_num);
            reset_dut();
            data_to_shift = 8'hAA;

            for (i = 0; i < 8; i = i + 1) begin
                si = data_to_shift[7-i];
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift in 0xFF", test_num);
            reset_dut();
            si = 1;
            repeat (8) @(posedge clk);

            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] data_to_shift;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift in 0x55 (01010101)", test_num);
            reset_dut();
            data_to_shift = 8'h55;

            for (i = 0; i < 8; i = i + 1) begin
                si = data_to_shift[7-i];
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift in 12 bits (0xABC)", test_num);
            reset_dut();


            si = 1; @(posedge clk);
            si = 0; @(posedge clk);
            si = 1; @(posedge clk);
            si = 0; @(posedge clk);



            si = 1; @(posedge clk);
            si = 0; @(posedge clk);
            si = 1; @(posedge clk);
            si = 1; @(posedge clk);
            si = 1; @(posedge clk);
            si = 1; @(posedge clk);
            si = 0; @(posedge clk);
            si = 0; @(posedge clk);

            #1;
            #1;

            check_outputs(8'hBC);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mid-operation Reset", test_num);
            reset_dut();


            si = 1; @(posedge clk);
            si = 1; @(posedge clk);
            si = 1; @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;

            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg_8bit Testbench");
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
        input [7:0] expected_po;
        begin
            if (expected_po === (expected_po ^ po ^ expected_po)) begin
                $display("PASS");
                $display("  Outputs: po=%h",
                         po);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: po=%h",
                         expected_po);
                $display("  Got:      po=%h",
                         po);
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
        $dumpvars(0,clk, rst, si, po);
    end

endmodule

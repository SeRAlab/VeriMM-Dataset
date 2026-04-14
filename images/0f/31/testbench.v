`timescale 1ns/1ps

module flash_memory_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg erase;
    reg write_enable;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory dut (
        .clk(clk),
        .data_in(data_in),
        .erase(erase),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        data_in = 5'b0;
        erase = 0;
        write_enable = 0;
        @(posedge clk);

        erase = 1;
        @(posedge clk);
        erase = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Testcase %03d: Basic Write and Read", test_num);
        data_in = 5'h1A;
        write_enable = 1;
        @(posedge clk);
        write_enable = 0;
        @(posedge clk);
        #1;

        check_outputs(5'h1A);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Testcase %03d: Erase Operation", test_num);

        data_in = 5'h0F;
        write_enable = 1;
        @(posedge clk);
        write_enable = 0;

        erase = 1;
        @(posedge clk);
        erase = 0;
        @(posedge clk);
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Testcase %03d: Overwrite Existing Data", test_num);

        data_in = 5'h11;
        write_enable = 1;
        @(posedge clk);

        data_in = 5'h05;
        write_enable = 1;
        @(posedge clk);
        write_enable = 0;
        @(posedge clk);
        #1;

        check_outputs(5'h05);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Testcase %03d: Write Enable Disable Check", test_num);

        data_in = 5'h12;
        write_enable = 1;
        @(posedge clk);

        data_in = 5'h1F;
        write_enable = 0;
        @(posedge clk);
        #1;

        check_outputs(5'h12);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Testcase %03d: Erase Priority check", test_num);

        data_in = 5'h15;
        write_enable = 1;
        erase = 1;
        @(posedge clk);
        write_enable = 0;
        erase = 0;
        @(posedge clk);


        #1;



        check_outputs(5'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        $display("Testcase %03d: Write Maximum Value (5'h1F)", test_num);
        data_in = 5'h1F;
        write_enable = 1;
        @(posedge clk);
        write_enable = 0;
        @(posedge clk);
        #1;

        check_outputs(5'h1F);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        $display("Testcase %03d: Data Persistence", test_num);
        data_in = 5'h0A;
        write_enable = 1;
        @(posedge clk);
        write_enable = 0;
        data_in = 5'h00;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(5'h0A);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("flash_memory Testbench");
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
        input [4:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, erase, write_enable, data_out);
    end

endmodule

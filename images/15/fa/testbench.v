`timescale 1ns/1ps

module nvme_controller_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr;
    reg clk;
    reg [7:0] cmd;
    reg cmd_valid;
    reg process;
    reg reset;
    wire [31:0] out_addr;
    wire [7:0] out_cmd;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_controller dut (
        .addr(addr),
        .clk(clk),
        .cmd(cmd),
        .cmd_valid(cmd_valid),
        .process(process),
        .reset(reset),
        .out_addr(out_addr),
        .out_cmd(out_cmd),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            cmd = 0;
            addr = 0;
            cmd_valid = 0;
            process = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Command Storage and Processing", test_num);
            reset_dut();


            cmd = 8'hA5;
            addr = 32'h12345678;
            cmd_valid = 1;
            @(posedge clk);
            #1 cmd_valid = 0;


            process = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678, 8'hA5, 1'b1);
            process = 0;
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting Internal Registers", test_num);
            reset_dut();


            cmd = 8'h11;
            addr = 32'hAAAA_AAAA;
            cmd_valid = 1;
            @(posedge clk);


            #1 cmd = 8'h22;
            addr = 32'hBBBB_BBBB;
            @(posedge clk);
            #1 cmd_valid = 0;


            process = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hBBBB_BBBB, 8'h22, 1'b1);
            process = 0;
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Effect on Stored Data", test_num);
            reset_dut();


            cmd = 8'hFF;
            addr = 32'hFFFF_FFFF;
            cmd_valid = 1;
            @(posedge clk);
            #1 cmd_valid = 0;


            reset = 1;
            @(posedge clk);
            #1 reset = 0;


            process = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 8'h0, 1'b1);
            process = 0;
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Ready signal low without process", test_num);
            reset_dut();


            cmd = 8'h55;
            addr = 32'hDEADBEEF;
            cmd_valid = 1;
            @(posedge clk);
            #1 cmd_valid = 0;


            repeat(3) @(posedge clk);
            #1;


            if (ready === 1'b0) begin
                $display("PASS: Ready is low");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Ready is high without process signal");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive Command Processing", test_num);
            reset_dut();


            cmd = 8'h01; addr = 32'h1000; cmd_valid = 1;
            @(posedge clk);
            #1 cmd_valid = 0; process = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h1000, 8'h01, 1'b1);


            #1 process = 0; cmd = 8'h02; addr = 32'h2000; cmd_valid = 1;
            @(posedge clk);
            #1 cmd_valid = 0; process = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h2000, 8'h02, 1'b1);
            process = 0;
            @(posedge clk);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nvme_controller Testbench");
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
        input [31:0] expected_out_addr;
        input [7:0] expected_out_cmd;
        input expected_ready;
        begin
            if (expected_out_addr === (expected_out_addr ^ out_addr ^ expected_out_addr) &&
                expected_out_cmd === (expected_out_cmd ^ out_cmd ^ expected_out_cmd) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: out_addr=%h, out_cmd=%h, ready=%b",
                         out_addr, out_cmd, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_addr=%h, out_cmd=%h, ready=%b",
                         expected_out_addr, expected_out_cmd, expected_ready);
                $display("  Got:      out_addr=%h, out_cmd=%h, ready=%b",
                         out_addr, out_cmd, ready);
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
        $dumpvars(0,addr, clk, cmd, cmd_valid, process, reset, out_addr, out_cmd, ready);
    end

endmodule

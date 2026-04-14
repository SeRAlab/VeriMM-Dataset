`timescale 1ns/1ps

module FSM_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [28:0] rom_q;
    wire done;
    wire [10:0] pe;
    wire [5:0] ram_a_addr;
    wire [5:0] ram_b_addr;
    wire ram_b_w;
    wire [8:0] rom_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    FSM dut (
        .clk(clk),
        .reset(reset),
        .rom_q(rom_q),
        .done(done),
        .pe(pe),
        .ram_a_addr(ram_a_addr),
        .ram_b_addr(ram_b_addr),
        .ram_b_w(ram_b_w),
        .rom_addr(rom_addr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            rom_q = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning testcase%03d: Addition Operation", test_num);
            reset_dut();


            rom_q = {4'h1, 6'h05, 6'h0A, 9'h000, 4'h0};


            repeat(5) @(posedge clk);



            #1;




            check_outputs(1'b0, 11'h001, 6'h05, 6'h0A, 1'b1, 9'h001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning testcase%03d: Multiplication Operation", test_num);
            reset_dut();


            rom_q = {4'h3, 6'h02, 6'h03, 9'h000, 4'h0};

            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b0, 11'h004, 6'h02, 6'h03, 1'b1, 9'h001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning testcase%03d: System Done Signal", test_num);
            reset_dut();


            rom_q = {4'hF, 6'h00, 6'h00, 9'h000, 4'h0};

            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 11'h000, 6'h00, 6'h00, 1'b0, 9'h001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("FSM Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        input expected_done;
        input [10:0] expected_pe;
        input [5:0] expected_ram_a_addr;
        input [5:0] expected_ram_b_addr;
        input expected_ram_b_w;
        input [8:0] expected_rom_addr;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_pe === (expected_pe ^ pe ^ expected_pe) &&
                expected_ram_a_addr === (expected_ram_a_addr ^ ram_a_addr ^ expected_ram_a_addr) &&
                expected_ram_b_addr === (expected_ram_b_addr ^ ram_b_addr ^ expected_ram_b_addr) &&
                expected_ram_b_w === (expected_ram_b_w ^ ram_b_w ^ expected_ram_b_w) &&
                expected_rom_addr === (expected_rom_addr ^ rom_addr ^ expected_rom_addr)) begin
                $display("PASS");
                $display("  Outputs: done=%b, pe=%h, ram_a_addr=%h, ram_b_addr=%h, ram_b_w=%b, rom_addr=%h",
                         done, pe, ram_a_addr, ram_b_addr, ram_b_w, rom_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, pe=%h, ram_a_addr=%h, ram_b_addr=%h, ram_b_w=%b, rom_addr=%h",
                         expected_done, expected_pe, expected_ram_a_addr, expected_ram_b_addr, expected_ram_b_w, expected_rom_addr);
                $display("  Got:      done=%b, pe=%h, ram_a_addr=%h, ram_b_addr=%h, ram_b_w=%b, rom_addr=%h",
                         done, pe, ram_a_addr, ram_b_addr, ram_b_w, rom_addr);
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
        $dumpvars(0,clk, reset, rom_q, done, pe, ram_a_addr, ram_b_addr, ram_b_w, rom_addr);
    end

endmodule

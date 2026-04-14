`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg flush;
    reg reset;
    reg [31:0] translated_address;
    reg translation_complete;
    reg [31:0] virtual_address;
    reg vm_enable;
    wire [31:0] physical_address;
    wire tlb_hit;
    wire translation_required;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .flush(flush),
        .reset(reset),
        .translated_address(translated_address),
        .translation_complete(translation_complete),
        .virtual_address(virtual_address),
        .vm_enable(vm_enable),
        .physical_address(physical_address),
        .tlb_hit(tlb_hit),
        .translation_required(translation_required)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            flush = 0;
            enable = 0;
            vm_enable = 0;
            virtual_address = 0;
            translated_address = 0;
            translation_complete = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            vm_enable = 0;
            enable = 1;
            virtual_address = 32'hAAAA_BBBB;
            @(posedge clk);

            #1;


            check_outputs(32'hAAAA_BBBB, 0, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            vm_enable = 1;
            enable = 1;
            virtual_address = 32'h1000_0000;
            @(posedge clk);
            #1;

            if (translation_required === 1) begin
                translated_address = 32'h5555_0000;
                translation_complete = 1;
                @(posedge clk);
                #1;
                translation_complete = 0;
                @(posedge clk);
            end

            #1;


            check_outputs(32'h5555_0000, 1, 0);
        end
        endtask

    task testcase003;

        reg [31:0] v_addrs [0:3];
        reg [31:0] p_addrs [0:3];
        integer i;
        begin
            reset_dut();
            v_addrs[0] = 32'h1000; v_addrs[1] = 32'h2000; v_addrs[2] = 32'h3000; v_addrs[3] = 32'h4000;
            p_addrs[0] = 32'hA000; p_addrs[1] = 32'hB000; p_addrs[2] = 32'hC000; p_addrs[3] = 32'hD000;

            vm_enable = 1;
            enable = 1;


            for (i = 0; i < 4; i = i + 1) begin
                virtual_address = v_addrs[i];
                @(posedge clk);
                #1;
                translated_address = p_addrs[i];
                translation_complete = 1;
                @(posedge clk);
                #1;
                translation_complete = 0;
            end


            virtual_address = 32'h4000;
            @(posedge clk);
            #1;

            check_outputs(32'hD000, 1, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            vm_enable = 1;
            enable = 1;
            virtual_address = 32'h1234_5678;
            @(posedge clk);
            #1;

            translated_address = 32'h8765_4321;
            translation_complete = 1;
            @(posedge clk);
            #1;
            translation_complete = 0;
            @(posedge clk);
            #1;


            flush = 1;
            @(posedge clk);
            #1;
            flush = 0;
            @(posedge clk);


            #1;



            check_outputs(physical_address, 0, 1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            vm_enable = 1;
            enable = 1;


            for (i = 0; i < 4; i = i + 1) begin
                virtual_address = (i + 1) << 12;
                @(posedge clk); #1;
                translated_address = (i + 1) << 16;
                translation_complete = 1;
                @(posedge clk); #1;
                translation_complete = 0;
            end


            virtual_address = 32'h5000;
            @(posedge clk); #1;
            translated_address = 32'h5000_0000;
            translation_complete = 1;
            @(posedge clk); #1;
            translation_complete = 0;
            @(posedge clk); #1;


            virtual_address = 32'h1000;
            @(posedge clk);
            #1;

            check_outputs(physical_address, 0, 1);
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
        input [31:0] expected_physical_address;
        input expected_tlb_hit;
        input expected_translation_required;
        begin
            if (expected_physical_address === (expected_physical_address ^ physical_address ^ expected_physical_address) &&
                expected_tlb_hit === (expected_tlb_hit ^ tlb_hit ^ expected_tlb_hit) &&
                expected_translation_required === (expected_translation_required ^ translation_required ^ expected_translation_required)) begin
                $display("PASS");
                $display("  Outputs: physical_address=%h, tlb_hit=%b, translation_required=%b",
                         physical_address, tlb_hit, translation_required);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: physical_address=%h, tlb_hit=%b, translation_required=%b",
                         expected_physical_address, expected_tlb_hit, expected_translation_required);
                $display("  Got:      physical_address=%h, tlb_hit=%b, translation_required=%b",
                         physical_address, tlb_hit, translation_required);
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
        $dumpvars(0,clk, enable, flush, reset, translated_address, translation_complete, virtual_address, vm_enable, physical_address, tlb_hit, translation_required);
    end

endmodule

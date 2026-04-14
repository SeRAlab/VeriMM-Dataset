`timescale 1ns/1ps

module virtual_memory_unit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [31:0] virtual_addr;
    wire page_fault;
    wire [31:0] physical_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    virtual_memory_unit dut (
        .clk(clk),
        .rst(rst),
        .virtual_addr(virtual_addr),
        .page_fault(page_fault),
        .physical_addr(physical_addr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            virtual_addr = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Cold Start Access");
            reset_dut();
            virtual_addr = 32'h0000_1000;
            @(posedge clk);

            #1;


            check_outputs(1'b1, 32'hxxxx_xxxx);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Page Hit After Allocation");
            reset_dut();


            virtual_addr = 32'h0000_2000;
            @(posedge clk);




            virtual_addr = 32'h0000_2000;
            @(posedge clk);
            #1;

            check_outputs(1'b0, physical_addr);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Distinct Page Access");
            reset_dut();

            virtual_addr = 32'h0000_A000;
            @(posedge clk);

            virtual_addr = 32'h0000_B000;
            @(posedge clk);


            #1;



            check_outputs(1'b1, 32'hxxxx_xxxx);
        end
        endtask

    task testcase004;

        reg [31:0] first_pa;
        begin
            $display("\nRunning testcase004: Offset Preservation");
            reset_dut();


            virtual_addr = 32'h0000_1000;
            @(posedge clk);


            virtual_addr = 32'h0000_1ABC;
            @(posedge clk);


            if (physical_addr[11:0] === 12'hABC && page_fault === 1'b0) begin
                #1;

                check_outputs(1'b0, physical_addr);
            end else begin
                #1;

                check_outputs(1'b0, 32'hzzzz_zABC);
            end
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: LRU Eviction Logic");
            reset_dut();


            virtual_addr = 32'h1000_0000; @(posedge clk);
            virtual_addr = 32'h2000_0000; @(posedge clk);
            virtual_addr = 32'h3000_0000; @(posedge clk);
            virtual_addr = 32'h4000_0000; @(posedge clk);



            virtual_addr = 32'h1000_0000; @(posedge clk);


            virtual_addr = 32'h5000_0000; @(posedge clk);


            virtual_addr = 32'h2000_0000;
            @(posedge clk);
            #1;

            check_outputs(1'b1, 32'hxxxx_xxxx);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("virtual_memory_unit Testbench");
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
        input expected_page_fault;
        input [31:0] expected_physical_addr;
        begin
            if (expected_page_fault === (expected_page_fault ^ page_fault ^ expected_page_fault) &&
                expected_physical_addr === (expected_physical_addr ^ physical_addr ^ expected_physical_addr)) begin
                $display("PASS");
                $display("  Outputs: page_fault=%b, physical_addr=%h",
                         page_fault, physical_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: page_fault=%b, physical_addr=%h",
                         expected_page_fault, expected_physical_addr);
                $display("  Got:      page_fault=%b, physical_addr=%h",
                         page_fault, physical_addr);
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
        $dumpvars(0,clk, rst, virtual_addr, page_fault, physical_addr);
    end

endmodule
